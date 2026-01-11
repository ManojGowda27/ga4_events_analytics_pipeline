# GA4 Event Analytics Pipeline
### Modern Data Stack Implementation using dbt & BigQuery

## 📋 Project Overview
This repository hosts a production-grade ELT pipeline that transforms raw, nested Google Analytics 4 (GA4) event logs into a Kimball-style Star Schema for marketing attribution and session analysis. 

**Key Engineering Challenges Solved:**
* **Nested JSON Handling:** Implemented custom Jinja macros to dynamically unnest complex `event_params` arrays.
* **Sessionization:** Reconstructed user sessions from raw event timestamps using SQL window functions (Lag/Sum) to calculate session duration and bounce rates.
* **Storage Optimization:** Utilized ephemeral models for intermediate logic to reduce BigQuery storage costs.

## 🏗️ Architecture
**Sources** (BigQuery Public) -> **Staging** (Flattened Views) -> **Intermediate** (Session Logic) -> **Marts** (Final Fact Tables)

## 🛠️ Tech Stack
* **Transformation:** dbt Core (v1.8)
* **Warehouse:** Google BigQuery
* **Orchestration:** GitHub Actions (CI/CD)
* **Language:** SQL (Standard) + Jinja2

## 🚀 Key Models
| Model | Type | Description |
| :--- | :--- | :--- |
| `stg_ga4__events` | View | Flattens raw nested JSON into columnar format using `unnest_key` macro. |
| `int_sessions__aggregated` | Ephemeral | Aggregates individual hits into session-level metrics (Duration, Page Views). |
| `fct_sessions` | Table | Final fact table with boolean flags (`is_bounce`) and attribution dimensions. |

## 💻 How to Run
1. **Setup:**
   ```bash
   python -m venv venv
   source venv/bin/activate
   pip install dbt-bigquery

2. **Run Models:**
    ```bash
    dbt run

3. **Generate Docs:**
    ```bash
    dbt docs generate && dbt docs serve
