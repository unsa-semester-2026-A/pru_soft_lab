import http from 'k6/http';
import { check, sleep } from 'k6';

/**
 * @fileoverview K6 Load Testing Script for TicketPass REST API.
 * 
 * Simulates virtual users browsing events and reserving tickets randomly across
 * different concerts and seat zones to evaluate load performance under realistic traffic.
 * 
 * Manual CLI Execution Examples:
 *   - Scenario A (20 VUs, 30s):  k6 run --vus 20 --duration 30s app/scripts/k6_test.js
 *   - Scenario B (50 VUs, 45s):  k6 run --vus 50 --duration 45s app/scripts/k6_test.js
 *   - Scenario C (100 VUs, 60s): k6 run --vus 100 --duration 60s app/scripts/k6_test.js
 *
 * Google JavaScript Style Guide compliant.
 */

export const options = {
  // Default configuration (Scenario A)
  vus: 20,
  duration: '30s',
  thresholds: {
    http_req_failed: ['rate<0.05'], // Error rate must be under 5%
    http_req_duration: ['p(95)<1500'], // 95% of requests must complete in < 1500ms
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:5000';

const EVENT_IDS = ['conc-001', 'conc-002', 'conc-003', 'conc-004', 'conc-005'];
const ZONE_IDS = ['vip', 'pref', 'gen'];

/**
 * Helper to select a random item from an array.
 * @param {Array} array
 * @return {*}
 */
function getRandomElement(array) {
  return array[Math.floor(Math.random() * array.length)];
}

/**
 * Executes default virtual user iteration.
 */
export default function () {
  // 1. Fetch events catalogue (Read operation)
  const eventsResponse = http.get(`${BASE_URL}/api/v1/eventos`);
  
  check(eventsResponse, {
    'GET /eventos status is 200': (r) => r.status === 200,
    'GET /eventos duration < 500ms': (r) => r.timings.duration < 500,
  });

  sleep(0.5);

  // Select random event and zone to distribute load realistically
  const selectedEvent = getRandomElement(EVENT_IDS);
  const selectedZone = getRandomElement(ZONE_IDS);
  const randomDni = Math.floor(10000000 + Math.random() * 90000000).toString();

  // 2. Reserve tickets (Atomic write operation in Redis)
  const reservationPayload = JSON.stringify({
    evento_id: selectedEvent,
    zona_id: selectedZone,
    cantidad: 1,
    nombre_comprador: 'Load Tester User',
    email_comprador: 'k6tester@example.com',
    dni_comprador: randomDni,
  });

  const requestParams = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const reservationResponse = http.post(
    `${BASE_URL}/api/v1/compras/reservar`,
    reservationPayload,
    requestParams
  );

  const isSuccess = check(reservationResponse, {
    'POST /compras/reservar status is 200/201': (r) => r.status === 200 || r.status === 201,
  });

  // Log error sample if request fails
  if (!isSuccess && __VU === 1 && __ITER < 3) {
    console.log(`[K6 DEBUG] POST /compras/reservar Failed! Status: ${reservationResponse.status}, Body: ${reservationResponse.body}`);
  }

  sleep(1);
}
