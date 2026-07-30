# PROFILE.md

## Purpose

This file is generated from `roadmap.db` after the initial profile and all numbered evaluations are loaded.

Do not edit ratings here; change the initial profile or add an evaluation SQL file, rebuild the database, and regenerate this document.

## Current Ratings

| Skill Cluster | Artifact | Reliability | Confidence | Status | Evidence | Current limitations |
|---|---:|---:|---|---|---|---|
| `APIS_WEB_APPS` | 2.5 | 1.5 | low | diagnostic_pending | Evidence from FastAPI endpoints, JSON responses, Flask dashboard routes, and simple templates. | Needs endpoint explanation, debugging, and small modification diagnostic. |
| `BIG_DATA_DATA_LAKE` | 0.0 | 0.0 | low | not_started | No accepted evidence yet. | Needs PySpark, Parquet, partitioning, and data lake layer evidence if this branch becomes active. |
| `BUSINESS_ANALYSIS` | 2.0 | 1.5 | low | diagnostic_pending | Evidence from basic report interpretation and metric summaries. | Needs stronger KPI interpretation, stakeholder-style questions, and business-rule translation. |
| `CLOUD_DATA_PLATFORMS` | 0.0 | 0.0 | low | not_started | No accepted evidence yet. | Needs cloud storage/database/warehouse basics if this branch becomes active. |
| `CONTAINERS_CI_CD` | 2.0 | 1.0 | low | diagnostic_pending | Evidence from Dockerfile, Docker Compose, and project containerization exposure. | Needs container build/run/debug and simple CI validation evidence. |
| `DATA_MODELING` | 2.5 | 2.0 | medium | updated_by_evaluation | Evaluation 001 repair gate: improved table relationship logic. | Needs stronger independent schema, grain, and relationship checks. |
| `DATA_QUALITY` | 3.0 | 3.0 | medium | updated_by_evaluation | Evaluation 003: independently created rule-level validation checks, preserved duplicate evidence, separated accepted and rejected rows, and reconciled record counts. | Needs broader multi-rule examples, source-contract documentation, and production handling of nullable text fields and unexpected schemas. |
| `DOCUMENTATION` | 3.0 | 2.5 | medium | diagnostic_pending | Evidence from README files, run instructions, project summaries, assumptions, limitations, and generated profile documents. | Needs concise project documentation rewrite and runbook diagnostic. |
| `ETL_PIPELINES` | 3.0 | 2.0 | low | diagnostic_pending | Evidence from raw-to-table loading, CSV exports, generated data, report creation, and script-based project workflows. | Needs stronger ETL evidence: raw to bronze/silver/gold or raw to clean to report pipeline with validation and logging. |
| `GEOSPATIAL` | 2.0 | 1.0 | low | diagnostic_pending | Evidence from GeoPandas loading, CRS handling, geographic merging, and Plotly choropleth mapping. | Needs independent geospatial cleanup and map explanation diagnostic. |
| `LINUX_SYSTEMS` | 2.0 | 1.5 | low | diagnostic_pending | Evidence from Linux terminal use, project execution, shell scripts, and environment handling. | Needs practical file/process/permissions/command diagnostic. |
| `MATH_STATS` | 2.0 | 1.0 | low | diagnostic_pending | Evidence from ML metrics exposure and ongoing math study. | Needs practical statistics diagnostic for distributions, averages, variance, correlation, hypothesis testing basics, and model evaluation. |
| `ML` | 2.5 | 1.5 | low | diagnostic_pending | Evidence from scikit-learn classifier workflow, train/test split, metrics, confusion matrix, prediction probability, and joblib model persistence. | Needs ML concept diagnostic focused on leakage, metrics, train/test split, and interpretation. |
| `MLOPS` | 1.0 | 0.5 | low | not_started | Minimal evidence from joblib model persistence and Docker exposure. | Needs model packaging, inference API, reproducibility, and monitoring basics if ML branch becomes active. |
| `NETWORKING_SECURITY` | 0.5 | 0.0 | low | not_started | Minimal indirect exposure through APIs and local services. | Needs HTTP, ports, environment variables, secrets, IAM/security basics if cloud branch becomes active. |
| `PROJECT_REASONING` | 3.0 | 3.0 | medium | updated_by_evaluation | Evaluation 002: demonstrated project flow, table relationships, data origins, and synthetic-data limitations. | A future unassisted project explanation would increase confidence. |
| `PYTHON_DATA_WORK` | 3.5 | 3.0 | medium | updated_by_evaluation | Evaluation 003: independently executed pandas pipeline for deduplication, normalization, conversion, validation, conditional revenue, grouping, assertions, and CSV output. | Needs cleaner production structure, defensive conversion on every input, reduced duplication, and more practice with report-ready indexes and output formatting. |
| `REPORTING` | 3.0 | 3.0 | medium | updated_by_evaluation | Evaluation 003: independently produced correct branch and monthly completed-revenue summaries and identified leading periods and branches. | Needs report-ready column layout, index-free exports, clearer findings output, visualization, and spreadsheet or BI reporting evidence. |
| `SQL_DATABASES` | 4.0 | 3.5 | medium | updated_by_evaluation | Evaluation 004: independently constructed and executed LEFT JOIN, HAVING, CTE, conditional-aggregation, and CASE queries on a fresh support-ticket schema while repairing multiple SQLite errors from execution feedback. | Needs consistent COALESCE handling after LEFT JOIN, exact adherence to requested anti-join and sorting requirements, semantic verification of final outputs, and later practice with window functions and top-per-group queries. |
| `SYNTHETIC_DATA` | 3.0 | 2.0 | medium | diagnostic_pending | Evidence from synthetic customers, sales, monitoring records, student records, dropout simulation, and weighted sampling. | Needs clearer documentation of assumptions, distributions, and limitations. |
| `TESTING_DEBUGGING` | 3.0 | 3.0 | medium | updated_by_evaluation | Evaluation 004: independently used SQLite error output to repair table names, column names, aliases, missing clauses, grouping references, and CASE syntax across repeated executions. | Needs stronger semantic debugging: compare final output against every requirement, deliberately test NULL cases, and add explicit verification queries or assertions instead of stopping when SQL executes. |
| `VISUALIZATION` | 2.5 | 1.5 | low | diagnostic_pending | Evidence from matplotlib charts and Plotly geospatial visualizations. | Needs chart selection, chart interpretation, and dashboard-style reporting practice. |
| `WORKFLOW_TOOLS` | 2.5 | 1.5 | low | diagnostic_pending | Evidence from GitHub project organization, Docker Compose, Dockerfile exposure, Linux terminal usage, requirements files, and run scripts. | Needs terminal/Git/Docker workflow diagnostic. |

## Evaluation History

| Evaluation ID | Name | Result | Score | Assistance | Evidence |
|---|---|---|---:|---|---|
| `pandas_data_quality_003` | Pandas Data Quality Evaluation 003 | passed | 8.8 | independent | See proofs/0003_pandas_data_quality.md. |
| `sql_independence_001` | SQL Independence Evaluation 001 | partial | 5.0 | assisted_acknowledged | See proofs/001_sql_data_quality_modeling.md. |
| `sql_independence_002` | Commerce SQL and Project Reasoning Evaluation | partial | 7.8 | assisted_acknowledged | See proofs/002_commerce_sql_project_reasoning.md. |
| `sql_independence_003` | SQL Joins, Aggregation, and CTE Evaluation 004 | passed | 7.6 | independent | See proofs/0004_sql_joins_aggregation_ctes.md. |
