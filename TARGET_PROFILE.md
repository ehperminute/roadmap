# TARGET_PROFILE.md

## Purpose

This file defines the current target profile for the learning system.

It states the next realistic bridge target, required skill clusters, minimum thresholds, and evidence needed to compare against `PROFILE.md`.

Shared skill definitions belong in `SKILL_MAP.md`.

Current ratings belong in `PROFILE.md`.

Evidence and diagnostic outcomes belong in `EVIDENCE_LOG.md`.

## Last Updated

2026-07-13

## Current Bridge Target

**Data Reporting / Data Quality Trainee**

## Target Definition

This target means the subject can perform small reporting and data-quality tasks with limited guidance in a familiar environment.

This is a bridge target toward broader data work.

It is not yet equivalent to:

* Data Engineer
* Data Scientist
* Machine Learning Engineer
* Analytics Engineer

## Market Basis

Current entry-ish data roles commonly emphasize:

* SQL
* Excel or Google Sheets
* Power BI or dashboard/reporting tools
* data validation
* reconciliation or master-data tasks
* basic data operations
* basic Python as an advantage

## Target Skill Thresholds

| Skill Cluster ID    | Target Reliability | Target Meaning                                                                                     |
| ------------------- | -----------------: | -------------------------------------------------------------------------------------------------- |
| `SQL_DATABASES`     |               4/10 | Can write basic reporting and validation queries with limited help.                                |
| `PYTHON_DATA_WORK`  |             3.5/10 | Can read, inspect, clean, group, and export CSV-style data.                                        |
| `DATA_QUALITY`      |               4/10 | Can design simple checks for invalid values, duplicates, missing references, and date consistency. |
| `REPORTING`         |               4/10 | Can create simple pivot/chart/report outputs and write basic observations.                         |
| `VISUALIZATION`     |               3/10 | Can produce or interpret simple charts without overclaiming.                                       |
| `WORKFLOW_TOOLS`    |               3/10 | Can run scripts, inspect files, use Git basics, and handle simple terminal workflows.              |
| `DOCUMENTATION`     |               4/10 | Can explain project purpose, setup, inputs, outputs, and limitations.                              |
| `PROJECT_REASONING` |               4/10 | Can explain how files and data flow through a project.                                             |

## Secondary Skill Thresholds

These are useful but not required as core gates for the bridge target.

| Skill Cluster ID | Target Reliability | Notes                                                               |
| ---------------- | -----------------: | ------------------------------------------------------------------- |
| `APIS_WEB_APPS`  |             2.5/10 | Helpful for API-backed reporting projects.                          |
| `ML_BASICS`      |             2.5/10 | Useful background from prior projects; not central for this target. |
| `SYNTHETIC_DATA` |               3/10 | Useful for practice data and portfolio projects.                    |
| `GEOSPATIAL`     |               2/10 | Useful evidence, but not central for the current bridge target.     |

## Not Active for This Target

These should not drive the next module yet:

* AWS
* dbt
* Airflow
* Dagster
* data warehouses
* data lakes/lakehouse
* advanced statistics
* advanced ML
* CI/CD
* Kubernetes
* production API design

## Evidence Required

### SQL Evidence

Required output:

* 15–20 SQL queries
* Includes:

  * filtering
  * sorting
  * joins
  * aggregation
  * date grouping
  * top-N report
  * validation query
  * duplicate check
  * missing-reference check
  * CASE expression

Pass threshold:

* 75% correct with limited help.

Linked skill clusters:

* `SQL_DATABASES`
* `DATA_QUALITY`

---

### pandas Evidence

Required output:

* read a CSV
* inspect columns
* identify missing or invalid values
* clean or transform at least two columns
* group and aggregate
* export result to CSV

Pass threshold:

* Task completed without full solution code being supplied.

Linked skill clusters:

* `PYTHON_DATA_WORK`
* `DATA_QUALITY`

---

### Reporting Evidence

Required output:

* one pivot table
* one chart
* three written observations
* one limitation note explaining synthetic data

Pass threshold:

* Report is understandable, technically correct, and does not invent real-world business conclusions from synthetic data.

Linked skill clusters:

* `REPORTING`
* `VISUALIZATION`
* `DOCUMENTATION`

---

### Project Explanation Evidence

Required output:

* explain the commerce pipeline at file/function level
* identify inputs and outputs
* explain the data flow
* explain where SQL, Python, PostgreSQL, reports, and charts fit

Pass threshold:

* Explanation is coherent without relying on a prepared script.

Linked skill clusters:

* `PROJECT_REASONING`
* `DOCUMENTATION`
* `SQL_DATABASES`
* `PYTHON_DATA_WORK`

---

### Workflow Evidence

Required output:

* run basic project commands
* inspect files
* use basic Git commands
* paste and interpret common errors

Pass threshold:

* Can complete routine project handling without losing state.

Linked skill clusters:

* `WORKFLOW_TOOLS`

## Completion Criteria

The target profile is reached when the following diagnostics are passed:

1. SQL independence diagnostic
2. pandas fundamentals diagnostic
3. spreadsheet/reporting diagnostic
4. project explanation diagnostic
5. Git/terminal basic workflow diagnostic

After passing, update:

* `EVIDENCE_LOG.md`
* `PROFILE.md`
* `MODULE_CURRENT.md`

## Expected Profile Movement After Completion

Approximate expected updates after evidence:

| Skill Cluster ID    | Expected Reliability After Passing |
| ------------------- | ---------------------------------: |
| `SQL_DATABASES`     |                               4/10 |
| `PYTHON_DATA_WORK`  |                             3.5/10 |
| `DATA_QUALITY`      |                               4/10 |
| `REPORTING`         |                               4/10 |
| `VISUALIZATION`     |                               3/10 |
| `WORKFLOW_TOOLS`    |                               3/10 |
| `DOCUMENTATION`     |                               4/10 |
| `PROJECT_REASONING` |                               4/10 |

These updates should happen only after diagnostics are recorded in `EVIDENCE_LOG.md`.
