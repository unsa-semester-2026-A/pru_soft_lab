# Step-by-Step Execution Guide - Laboratory 09: Performance & Security Testing

This document provides a comprehensive, step-by-step manual for deploying the **TicketPass** application, installing required dependencies, running performance and security test suites, and collecting required evidence and screenshots.

Follows the **Google Developer Documentation Style Guide**.

---

## 1. Prerequisites and Tool Installation

Verify that the following tools are installed on your system before proceeding:

1. **Docker and Docker Compose** (for running Redis, PostgreSQL, and the REST API in containers).
2. **Python 3.12+** and the `requests` library:
   ```bash
   pip install requests
   ```
3. **k6 (Grafana Labs)**:
   - *Linux (Ubuntu/Debian):*
     ```bash
     sudo gpg -k
     sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
     echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
     sudo apt-get update
     sudo apt-get install k6
     ```
   - *Windows (Chocolatey/Winget):* `winget install k6` or `choco install k6`.
4. **Apache JMeter 5.6+** (Requires Java 8+):
   - Download and extract from [jmeter.apache.org](https://jmeter.apache.org/download_jmeter.cgi).

---

## 2. Application Deployment and Initialization

### Step 2.1: Start Services with Docker Compose
Open a terminal and execute the following commands:

```bash
cd app
docker compose up --build -d
```

> REQUIRED SCREENSHOT #1:
> Run `docker compose ps` and capture the output showing all 4 containers in a `Running` state: `front` (:4322), `api` (:5000), `redis` (:6379), and `postgres` (:5433).

---

### Step 2.2: Seed the Database
Run the seed script inside the backend API container:

```bash
docker compose exec api uv run python seed.py
```

---

### Step 2.3: Client Health & Smoke Test
Run the initial verification script:

```bash
python app/scripts/cliente.py
```

> REQUIRED SCREENSHOT #2:
> Capture the terminal output of `cliente.py` confirming the `SUCCESS: API is operational and ready for testing.` message.

---

## 3. Run REST API Security Tests (Python)

Run the automated security suite to evaluate all 5 required test cases:

```bash
python app/scripts/security_tests.py
```

> REQUIRED SCREENSHOT #3:
> Capture the terminal output of `security_tests.py` confirming the execution of all 5 security test cases (404 Not Found, 400 Incomplete Payload, 400 Invalid Data Types, 405 Prohibited Method, and Case 5: Concurrent Brute Force / Rate Limit Attack Simulation).

---

## 4. Run Load Tests with K6

Execute the three load scenarios manually using K6 from the root terminal directory. Record key metrics for each run (Average Response Time, Max, P95, Throughput/RPS, and Failure Rate %):

### Scenario A: 20 Virtual Users (VUs) for 30 Seconds
```bash
k6 run --vus 20 --duration 30s app/scripts/k6_test.js
```
> REQUIRED SCREENSHOT #4: Terminal report output for K6 Scenario A.

### Scenario B: 50 Virtual Users (VUs) for 45 Seconds
```bash
k6 run --vus 50 --duration 45s app/scripts/k6_test.js
```
> REQUIRED SCREENSHOT #5: Terminal report output for K6 Scenario B.

### Scenario C: 100 Virtual Users (VUs) for 60 Seconds
```bash
k6 run --vus 100 --duration 60s app/scripts/k6_test.js
```
> REQUIRED SCREENSHOT #6: Terminal report output for K6 Scenario C.

---

## 5. Run Load Tests with Apache JMeter

### Step 5.1: Open the Test Plan in JMeter
1. Launch Apache JMeter (`jmeter` on Linux/macOS or `jmeter.bat` on Windows).
2. Click **File -> Open** and select:
   `app/scripts/jmeter_test_plan.jmx`

---

### Step 5.2: Execute the 3 JMeter Load Scenarios

For each scenario, select **Thread Group - TicketPass Load Scenario** in the left panel, update parameters, and click **Start (Green Play Button)**:

#### Scenario 1: 20 Concurrent Users
- **Number of Threads (users):** `20`
- **Ramp-Up period (seconds):** `10`
- **Loop Count:** `5`
> REQUIRED SCREENSHOT #7: JMeter **Summary Report** and **Aggregate Report** for 20 users.

#### Scenario 2: 50 Concurrent Users
- **Number of Threads (users):** `50`
- **Ramp-Up period (seconds):** `20`
- **Loop Count:** `10`
> REQUIRED SCREENSHOT #8: JMeter **Summary Report** and **Graph Results** for 50 users.

#### Scenario 3: 100 Concurrent Users
- **Number of Threads (users):** `100`
- **Ramp-Up period (seconds):** `30`
- **Loop Count:** `15`
> REQUIRED SCREENSHOT #9: JMeter **Summary Report**, **Aggregate Report**, and **Graph Results** for 100 users.

---

## 6. Summary of Screenshots for Final Report

Upon completing the test runs, collect and save the following screenshot artifacts:

1. `01_docker_compose_ps.png` - Active Docker container status.
2. `02_cliente_smoke_test.png` - Successful `cliente.py` output.
3. `03_security_tests_results.png` - Output of `security_tests.py` (Cases 1 to 5).
4. `04_k6_scenario_20vu.png` - K6 Scenario A results (20 VUs / 30s).
5. `05_k6_scenario_50vu.png` - K6 Scenario B results (50 VUs / 45s).
6. `06_k6_scenario_100vu.png` - K6 Scenario C results (100 VUs / 60s).
7. `07_jmeter_summary_20u.png` - JMeter Summary Report (20 users).
8. `08_jmeter_summary_50u.png` - JMeter Summary Report (50 users).
9. `09_jmeter_summary_100u.png` - JMeter Summary Report & Graph Results (100 users).

---

## 7. Next Steps
When you complete all manual test runs and gather screenshots, notify the agent in the chat to proceed with drafting the Typst report modules (`informe/content/`) and compiling the final `laboratorio.pdf`.
