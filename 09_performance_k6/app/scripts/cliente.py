#!/usr/bin/env python3
"""Client Smoke Test Script.

This module provides basic HTTP health checks and endpoint verification
for the TicketPass REST API prior to running performance and security suites.

Google Python Style Guide compliant.
"""

import sys
from typing import Any, Dict
import requests

BASE_URL = "http://localhost:5000"
TIMEOUT_SECONDS = 5


def test_health() -> bool:
    """Verifies that the API health endpoint responds with HTTP 200 OK.

    Returns:
        bool: True if the health check passes, False otherwise.
    """
    url = f"{BASE_URL}/health"
    print(f"[INFO] Sending GET request to {url}")
    try:
        response = requests.get(url, timeout=TIMEOUT_SECONDS)
        print(f"       HTTP Status Code: {response.status_code}")
        print(f"       JSON Payload:    {response.json()}")
        return response.status_code == 200
    except requests.RequestException as err:
        print(f"       [ERROR] Failed to connect to health endpoint: {err}")
        return False


def test_list_events() -> bool:
    """Retrieves the list of available events from the REST API.

    Returns:
        bool: True if event retrieval succeeds with HTTP 200 OK, False otherwise.
    """
    url = f"{BASE_URL}/api/v1/eventos"
    print(f"\n[INFO] Sending GET request to {url}")
    try:
        response = requests.get(url, timeout=TIMEOUT_SECONDS)
        print(f"       HTTP Status Code: {response.status_code}")
        events = response.json()
        print(f"       Retrieved {len(events)} events:")
        for event in events:
            event_id = event.get("id")
            name = event.get("nombre")
            stock = event.get("stock_total")
            print(f"         - [{event_id}] {name} (Total Stock: {stock})")
        return response.status_code == 200
    except requests.RequestException as err:
        print(f"       [ERROR] Failed to list events: {err}")
        return False


def main() -> None:
    """Executes the client smoke test suite and exits with status code."""
    print("=" * 60)
    print(" SMOKE TEST / HEALTH CHECK - TICKETPASS API")
    print("=" * 60)

    health_success = test_health()
    events_success = test_list_events()

    print("=" * 60)
    if health_success and events_success:
        print(" SUCCESS: API is operational and ready for testing.")
        sys.exit(0)
    else:
        print(" ERROR: API smoke test failed.")
        sys.exit(1)


if __name__ == "__main__":
    main()
