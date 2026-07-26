PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- Baseline reconstructed from accepted project artifacts.
-- This file contains no evaluation outcomes.

INSERT INTO profile_skill_state (
    skill_cluster_id,
    artifact_rating,
    reliability_rating,
    confidence_level,
    rating_status,
    evidence_summary,
    current_limitations
)
VALUES
('APIS_WEB_APPS', 2.5, 1.5, 'low', 'diagnostic_pending', 'Evidence from FastAPI endpoints, JSON responses, Flask dashboard routes, and simple templates.', 'Needs endpoint explanation, debugging, and small modification diagnostic.'),
('BIG_DATA_DATA_LAKE', 0.0, 0.0, 'low', 'not_started', 'No accepted evidence yet.', 'Needs PySpark, Parquet, partitioning, and data lake layer evidence if this branch becomes active.'),
('BUSINESS_ANALYSIS', 2.0, 1.5, 'low', 'diagnostic_pending', 'Evidence from basic report interpretation and metric summaries.', 'Needs stronger KPI interpretation, stakeholder-style questions, and business-rule translation.'),
('CLOUD_DATA_PLATFORMS', 0.0, 0.0, 'low', 'not_started', 'No accepted evidence yet.', 'Needs cloud storage/database/warehouse basics if this branch becomes active.'),
('CONTAINERS_CI_CD', 2.0, 1.0, 'low', 'diagnostic_pending', 'Evidence from Dockerfile, Docker Compose, and project containerization exposure.', 'Needs container build/run/debug and simple CI validation evidence.'),
('DATA_MODELING', 2.5, 1.5, 'low', 'diagnostic_pending', 'Evidence from relational schema creation, primary keys, foreign keys, product/customer/sales structure, and basic relationships.', 'Needs data modeling diagnostic covering grain, keys, normalization, facts/dimensions, and schema explanation.'),
('DATA_QUALITY', 3.0, 2.0, 'medium', 'diagnostic_pending', 'Evidence from invalid-value checks, missing reference checks, sale-date checks, duplicate-style validation, and synthetic-data limitations.', 'Needs independent data-quality diagnostic with messy data and reconciliation checks.'),
('DOCUMENTATION', 3.0, 2.5, 'medium', 'diagnostic_pending', 'Evidence from README files, run instructions, project summaries, assumptions, limitations, and generated profile documents.', 'Needs concise project documentation rewrite and runbook diagnostic.'),
('ETL_PIPELINES', 3.0, 2.0, 'low', 'diagnostic_pending', 'Evidence from raw-to-table loading, CSV exports, generated data, report creation, and script-based project workflows.', 'Needs stronger ETL evidence: raw to bronze/silver/gold or raw to clean to report pipeline with validation and logging.'),
('GEOSPATIAL', 2.0, 1.0, 'low', 'diagnostic_pending', 'Evidence from GeoPandas loading, CRS handling, geographic merging, and Plotly choropleth mapping.', 'Needs independent geospatial cleanup and map explanation diagnostic.'),
('LINUX_SYSTEMS', 2.0, 1.5, 'low', 'diagnostic_pending', 'Evidence from Linux terminal use, project execution, shell scripts, and environment handling.', 'Needs practical file/process/permissions/command diagnostic.'),
('MATH_STATS', 2.0, 1.0, 'low', 'diagnostic_pending', 'Evidence from ML metrics exposure and ongoing math study.', 'Needs practical statistics diagnostic for distributions, averages, variance, correlation, hypothesis testing basics, and model evaluation.'),
('ML', 2.5, 1.5, 'low', 'diagnostic_pending', 'Evidence from scikit-learn classifier workflow, train/test split, metrics, confusion matrix, prediction probability, and joblib model persistence.', 'Needs ML concept diagnostic focused on leakage, metrics, train/test split, and interpretation.'),
('MLOPS', 1.0, 0.5, 'low', 'not_started', 'Minimal evidence from joblib model persistence and Docker exposure.', 'Needs model packaging, inference API, reproducibility, and monitoring basics if ML branch becomes active.'),
('NETWORKING_SECURITY', 0.5, 0.0, 'low', 'not_started', 'Minimal indirect exposure through APIs and local services.', 'Needs HTTP, ports, environment variables, secrets, IAM/security basics if cloud branch becomes active.'),
('PROJECT_REASONING', 3.0, 2.0, 'medium', 'diagnostic_pending', 'Evidence from multiple project artifacts and ability to discuss file roles, data flow, and project limitations.', 'Needs direct project explanation diagnostic using the commerce pipeline or another selected project.'),
('PYTHON_DATA_WORK', 3.5, 2.5, 'medium', 'diagnostic_pending', 'Evidence from Python scripts for data generation, CSV handling, pandas workflows, exports, and project automation.', 'Needs independent pandas/Python diagnostic without full solution scaffolding.'),
('REPORTING', 3.0, 2.5, 'medium', 'diagnostic_pending', 'Evidence from CSV reports, revenue summaries, charts, and written observations.', 'Needs stronger spreadsheet/BI reporting diagnostic with pivot tables, charts, and metric interpretation.'),
('SQL_DATABASES', 3.0, 2.0, 'medium', 'diagnostic_pending', 'Evidence from PostgreSQL/SQLite projects, schema creation, joins, aggregations, report queries, and quality checks.', 'Needs independent SQL diagnostic covering joins, aggregation, CTEs, date grouping, validation queries, and query explanation.'),
('SYNTHETIC_DATA', 3.0, 2.0, 'medium', 'diagnostic_pending', 'Evidence from synthetic customers, sales, monitoring records, student records, dropout simulation, and weighted sampling.', 'Needs clearer documentation of assumptions, distributions, and limitations.'),
('TESTING_DEBUGGING', 2.0, 1.0, 'low', 'diagnostic_pending', 'Evidence from some error handling, validation checks, connection checks, and project debugging.', 'Needs explicit tests, debugging notes, error tracing, and regression checks.'),
('VISUALIZATION', 2.5, 1.5, 'low', 'diagnostic_pending', 'Evidence from matplotlib charts and Plotly geospatial visualizations.', 'Needs chart selection, chart interpretation, and dashboard-style reporting practice.'),
('WORKFLOW_TOOLS', 2.5, 1.5, 'low', 'diagnostic_pending', 'Evidence from GitHub project organization, Docker Compose, Dockerfile exposure, Linux terminal usage, requirements files, and run scripts.', 'Needs terminal/Git/Docker workflow diagnostic.');

-- Record one baseline event per skill.
INSERT INTO profile_rating_events (
    skill_cluster_id,
    artifact_rating,
    reliability_rating,
    confidence_level,
    rating_status,
    reason
)
SELECT
    skill_cluster_id,
    artifact_rating,
    reliability_rating,
    confidence_level,
    rating_status,
    'Initial profile reconstructed from accepted project artifacts.'
FROM profile_skill_state;

UPDATE profile_skill_state
SET last_event_id = (
    SELECT e.id
    FROM profile_rating_events e
    WHERE e.skill_cluster_id = profile_skill_state.skill_cluster_id
      AND e.diagnostic_id IS NULL
    ORDER BY e.id DESC
    LIMIT 1
);

COMMIT;
