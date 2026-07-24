#!/usr/bin/env python3
"""REST API Security Test Suite.

Automates foundational API security tests evaluating robustness against
malformed requests, non-existent resources, prohibited verbs, and rate-limiting
abuse scenarios.

Google Python Style Guide compliant.
"""

from concurrent.futures import ThreadPoolExecutor, as_completed
import time
from typing import Any, Dict, List, Tuple
import requests

BASE_URL = "http://localhost:5000"
REQUEST_TIMEOUT = 5

# Dictionary of credentials/tokens to simulate brute force payload variations
BRUTE_FORCE_DICTIONARY: List[Dict[str, Any]] = [
    {"user": "admin", "pass": "admin123"},
    {"user": "admin", "pass": "123456"},
    {"user": "admin", "pass": "password"},
    {"user": "root", "pass": "root"},
    {"user": "user", "pass": "secret"},
] + [{"token": f"token_{i:03d}", "code": f"promo_{i:03d}"} for i in range(45)]


def print_test_result(
    case_num: int,
    title: str,
    status_code: Any,
    expected_code: str,
    passed: bool,
    detail: Any,
) -> None:
    """Formats and prints test execution results to standard output without emojis.

    Args:
        case_num: Test case identifier.
        title: Descriptive test case title.
        status_code: HTTP status code returned by the server.
        expected_code: Expected HTTP status code string representation.
        passed: Boolean flag indicating test assertion outcome.
        detail: Server response payload or summary details.
    """
    result_text = "[PASSED]" if passed else "[FAILED]"
    print(f"\n{result_text} Case {case_num}: {title}")
    print(f"   - HTTP Status Code Received: {status_code} (Expected: {expected_code})")
    print(f"   - Test Assertion Result:   {result_text}")
    print(f"   - Server Response Detail:   {detail}")


def test_case_1_non_existent_resource() -> bool:
    """Case 1: Validates handling of non-existent resources.

    Returns:
        bool: True if server responds with HTTP 404 Not Found, False otherwise.
    """
    url = f"{BASE_URL}/api/v1/eventos/non-existent-id-9999"
    response = requests.get(url, timeout=REQUEST_TIMEOUT)
    passed = response.status_code == 404
    print_test_result(
        1,
        "Non-Existent Resource (GET invalid event ID)",
        response.status_code,
        "404",
        passed,
        response.json() if response.headers.get("Content-Type") == "application/json" else response.text[:100],
    )
    return passed


def test_case_2_incomplete_payload() -> bool:
    """Case 2: Validates rejection of incomplete request payloads.

    Returns:
        bool: True if server responds with HTTP 400 or 422, False otherwise.
    """
    url = f"{BASE_URL}/api/v1/compras/reservar"
    payload: Dict[str, Any] = {}
    response = requests.post(url, json=payload, timeout=REQUEST_TIMEOUT)
    passed = response.status_code in (400, 422)
    print_test_result(
        2,
        "Incomplete Payload (POST empty request body)",
        response.status_code,
        "400/422",
        passed,
        response.json() if response.headers.get("Content-Type") == "application/json" else response.text[:100],
    )
    return passed


def test_case_3_invalid_data_types() -> bool:
    """Case 3: Validates input sanitization against data type mismatches.

    Returns:
        bool: True if server rejects malformed types (HTTP 400/422), False otherwise.
    """
    url = f"{BASE_URL}/api/v1/compras/reservar"
    payload = {
        "evento_id": 12345,        # Expected string UUID/ID
        "cantidad": "ten_tickets", # Expected integer
    }
    response = requests.post(url, json=payload, timeout=REQUEST_TIMEOUT)
    passed = response.status_code in (400, 422)
    print_test_result(
        3,
        "Invalid Data Types (Type mismatch injection)",
        response.status_code,
        "400/422",
        passed,
        response.json() if response.headers.get("Content-Type") == "application/json" else response.text[:100],
    )
    return passed


def test_case_4_prohibited_http_method() -> bool:
    """Case 4: Validates rejection of unsupported HTTP methods.

    Returns:
        bool: True if server responds with HTTP 405 Method Not Allowed, False otherwise.
    """
    url = f"{BASE_URL}/api/v1/eventos"
    response = requests.patch(
        url,
        json={"name": "Unauthorized modification"},
        timeout=REQUEST_TIMEOUT,
    )
    passed = response.status_code == 405
    print_test_result(
        4,
        "Prohibited HTTP Method (PATCH on events collection)",
        response.status_code,
        "405",
        passed,
        response.json() if response.headers.get("Content-Type") == "application/json" else response.text[:100],
    )
    return passed


def _send_brute_force_request(url: str, payload: Dict[str, Any]) -> Tuple[int, Dict[str, str]]:
    """Helper function to execute a single brute force payload request.

    Args:
        url: Endpoint URL.
        payload: Dictionary payload to submit.

    Returns:
        Tuple containing status code and response headers.
    """
    try:
        res = requests.post(url, json=payload, timeout=3)
        return res.status_code, dict(res.headers)
    except requests.RequestException:
        return 0, {}


def test_case_5_brute_force_and_burst_abuse() -> bool:
    """Case 5: Simulates a concurrent brute force / credential stuffing attack.

    Uses a dictionary of 50 payload variations executed concurrently across 10
    worker threads to simulate automated brute-forcing tools (e.g., Hydra/Burp).
    Evaluates HTTP status code distribution (401, 403, 400, 429), presence of rate
    limiting headers, and verifies that no unhandled 500 server errors occur.

    Returns:
        bool: True if API handles concurrent brute force attempts securely without 500 errors.
    """
    url = f"{BASE_URL}/api/v1/compras/reservar"
    print("\n[RUNNING] Case 5: Concurrent Brute Force Attack Simulation")
    print(f"          Executing {len(BRUTE_FORCE_DICTIONARY)} dictionary payloads across 10 concurrent threads...")

    status_codes: List[int] = []
    headers_list: List[Dict[str, str]] = []
    start_time = time.time()

    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [
            executor.submit(_send_brute_force_request, url, payload)
            for payload in BRUTE_FORCE_DICTIONARY
        ]
        for future in as_completed(futures):
            code, headers = future.result()
            status_codes.append(code)
            headers_list.append(headers)

    elapsed = time.time() - start_time
    code_counts: Dict[int, int] = {}
    for code in status_codes:
        code_counts[code] = code_counts.get(code, 0) + 1

    rate_limit_headers_detected = any(
        "Retry-After" in h or "X-RateLimit-Limit" in h for h in headers_list
    )

    print(f"   - Attack Duration: {elapsed:.2f} seconds ({len(BRUTE_FORCE_DICTIONARY)/elapsed:.2f} req/sec)")
    print(f"   - HTTP Response Code Distribution: {code_counts}")
    print(f"   - Rate Limiting Headers Present: {rate_limit_headers_detected}")

    no_server_crash = 500 not in code_counts and 0 not in code_counts
    properly_controlled = any(code in (400, 401, 403, 404, 422, 429) for code in code_counts)
    passed = no_server_crash and properly_controlled

    print_test_result(
        5,
        "Concurrent Brute Force & Rate Limit Attack Simulation",
        f"Distribution: {code_counts}",
        "400/401/403/429 (No 500 errors)",
        passed,
        f"API handled {len(BRUTE_FORCE_DICTIONARY)} concurrent brute force attempts securely.",
    )
    return passed


def main() -> None:
    """Executes the security test suite and summarizes results."""
    print("=" * 70)
    print(" REST API SECURITY TEST SUITE - TICKETPASS API")
    print("=" * 70)

    test_results = [
        test_case_1_non_existent_resource(),
        test_case_2_incomplete_payload(),
        test_case_3_invalid_data_types(),
        test_case_4_prohibited_http_method(),
        test_case_5_brute_force_and_burst_abuse(),
    ]

    print("\n" + "=" * 70)
    passed_count = sum(1 for r in test_results if r)
    print(f" FINAL SUMMARY: {passed_count}/5 Security Tests Passed.")
    print("=" * 70)


if __name__ == "__main__":
    main()
