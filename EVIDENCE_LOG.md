# EVIDENCE_LOG.md

## Purpose

This file stores summarized evidence from projects and diagnostics.

Raw repository digests belong in `history/`.

This file should contain:

* project evidence summaries
* diagnostic results
* evaluation outcomes
* profile update justifications

## Last Updated

2026-07-13

## Evidence Types

| Evidence Type     | Meaning                                                                        |
| ----------------- | ------------------------------------------------------------------------------ |
| Project artifact  | Existing code, README, reports, scripts, dashboards, notebooks, or repo digest |
| Diagnostic result | A task completed specifically to test current ability                          |
| Evaluation result | Pass/fail or score after diagnostic review                                     |
| Profile update    | Skill rating change based on evidence                                          |

## Project Evidence

### Commerce Pipeline

Raw evidence:

* `history/commerce-pipeline-8a5edab282632443(1).txt`

Evidence summary:

* Python/PostgreSQL commerce reporting pipeline
* synthetic product/customer/sales data
* PostgreSQL schema creation
* data loading with `psycopg2`
* reusable SQL analytics queries
* data quality checks
* CSV report exports
* basic chart generation
* Docker Compose PostgreSQL setup
* minimal PostgreSQL CLI helper

Relevant skill clusters:

* `SQL_DATABASES`
* `PYTHON_DATA_WORK`
* `DATA_QUALITY`
* `REPORTING`
* `WORKFLOW_TOOLS`
* `DOCUMENTATION`

Verification status:

* Artifact baseline accepted
* Independent SQL diagnostic pending
* Project explanation diagnostic pending

---

### FastAPI PostgreSQL Stats API

Raw evidence:

* `history/fastapi-postgres-pandas-8a5edab282632443.txt`

Evidence summary:

* FastAPI app
* PostgreSQL connection
* SQL aggregation endpoints
* JSON API responses
* Docker Compose PostgreSQL setup
* shell run script

Relevant skill clusters:

* `APIS`
* `SQL_DATABASES`
* `WORKFLOW_TOOLS`

Verification status:

* Artifact baseline accepted
* Independent API modification diagnostic pending

---

### Cattle Monitor

Raw evidence:

* `history/cattle-monitor-8a5edab282632443.txt`

Evidence summary:

* Flask dashboard
* pandas/numpy data handling
* synthetic monitoring data
* scikit-learn RandomForest model
* train/test split
* classification report and confusion matrix
* joblib model persistence
* prediction probabilities
* HTML templates
* Dockerfile

Relevant skill clusters:

* `PYTHON_DATA_WORK`
* `ML_BASICS`
* `APIS_WEB_APPS`
* `VISUALIZATION`
* `WORKFLOW_TOOLS`

Verification status:

* Artifact baseline accepted
* ML concept diagnostic pending
* Flask/dashboard modification diagnostic pending

---

### Synthetic Geo Data CDMX

Raw evidence:

* `history/synthetic-geo-data-cdmx-8a5edab282632443.txt`

Evidence summary:

* synthetic student population generation
* semester-level dropout simulation
* SQLite analytics
* GeoPandas processing
* CRS transformation
* area/population proxy weighting
* Plotly visualization
* choropleth risk mapping
* Colab-oriented workflow

Relevant skill clusters:

* `PYTHON_DATA_WORK`
* `SQL_DATABASES`
* `SYNTHETIC_DATA`
* `GEOSPATIAL`
* `VISUALIZATION`

Verification status:

* Artifact baseline accepted
* Geospatial concept diagnostic pending
* pandas transformation diagnostic pending

## Diagnostic Results

No formal diagnostics recorded yet.

## Pending Diagnostics

| Diagnostic               | Purpose                                                 | Related Skill Clusters               |
| ------------------------ | ------------------------------------------------------- | ------------------------------------ |
| Project explanation      | Confirm understanding of project structure and workflow | `DOCUMENTATION`, `PROJECT_REASONING` |
| SQL independence         | Confirm ability to write unseen queries                 | `SQL_DATABASES`, `DATA_QUALITY`      |
| pandas fundamentals      | Confirm CSV cleaning/transformation ability             | `PYTHON_DATA_WORK`                   |
| Spreadsheet reporting    | Confirm pivot/chart/reporting ability                   | `REPORTING`                          |
| Git/terminal reliability | Confirm basic project handling                          | `WORKFLOW_TOOLS`                     |
| ML concept check         | Confirm conceptual understanding of model workflow      | `ML_BASICS`                          |

## Profile Update Log

No diagnostic-based profile updates yet.

Current profile ratings are artifact-based estimates.
