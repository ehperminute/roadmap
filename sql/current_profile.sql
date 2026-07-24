PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- ============================================================
-- Current profile system
-- ============================================================

-- If an older view named current_profile_ratings exists, remove it.
-- Current profile should be stored in profile_skill_state, not only inferred.
DROP VIEW IF EXISTS current_profile_ratings;
DROP VIEW IF EXISTS current_profile_vs_active_target;
DROP VIEW IF EXISTS current_profile_vs_target;
DROP VIEW IF EXISTS current_profile_gap_summary;

-- ============================================================
-- Rating event history
-- ============================================================

CREATE TABLE IF NOT EXISTS profile_rating_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    skill_cluster_id TEXT NOT NULL,

    artifact_rating REAL NOT NULL CHECK (artifact_rating BETWEEN 0 AND 10),
    reliability_rating REAL NOT NULL CHECK (reliability_rating BETWEEN 0 AND 10),

    confidence_level TEXT NOT NULL CHECK (
        confidence_level IN ('low', 'medium', 'high')
    ),

    rating_status TEXT NOT NULL CHECK (
        rating_status IN (
            'not_started',
            'artifact_based_estimate',
            'diagnostic_pending',
            'diagnostic_passed',
            'diagnostic_failed',
            'updated_by_evaluation',
            'manual_adjustment'
        )
    ),

    reason TEXT NOT NULL,

    evidence_item_id INTEGER,
    diagnostic_attempt_id INTEGER,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id),
    FOREIGN KEY (evidence_item_id) REFERENCES evidence_items(id),
    FOREIGN KEY (diagnostic_attempt_id) REFERENCES diagnostic_attempts(id)
);

-- ============================================================
-- Current profile state
-- ============================================================

CREATE TABLE IF NOT EXISTS profile_skill_state (
    skill_cluster_id TEXT PRIMARY KEY,

    artifact_rating REAL NOT NULL CHECK (artifact_rating BETWEEN 0 AND 10),
    reliability_rating REAL NOT NULL CHECK (reliability_rating BETWEEN 0 AND 10),

    confidence_level TEXT NOT NULL CHECK (
        confidence_level IN ('low', 'medium', 'high')
    ),

    rating_status TEXT NOT NULL CHECK (
        rating_status IN (
            'not_started',
            'artifact_based_estimate',
            'diagnostic_pending',
            'diagnostic_passed',
            'diagnostic_failed',
            'updated_by_evaluation',
            'manual_adjustment'
        )
    ),

    evidence_summary TEXT,
    current_limitations TEXT,
    next_diagnostic_id TEXT,
    last_event_id INTEGER,

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id),
    FOREIGN KEY (next_diagnostic_id) REFERENCES diagnostics(id),
    FOREIGN KEY (last_event_id) REFERENCES profile_rating_events(id)
);

-- ============================================================
-- Seed current profile state
-- These are baseline estimates from existing project artifacts.
-- Diagnostics will update these later.
-- ============================================================

INSERT INTO profile_skill_state
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, evidence_summary, current_limitations, next_diagnostic_id)
VALUES
('SQL_DATABASES', 3.0, 2.0, 'medium', 'diagnostic_pending',
 'Evidence from PostgreSQL/SQLite projects, schema creation, joins, aggregations, report queries, and quality checks.',
 'Needs independent SQL diagnostic covering joins, aggregation, CTEs, date grouping, validation queries, and query explanation.',
 'sql_independence_001'),

('PYTHON_DATA_WORK', 3.5, 2.5, 'medium', 'diagnostic_pending',
 'Evidence from Python scripts for data generation, CSV handling, pandas workflows, exports, and project automation.',
 'Needs independent pandas/Python diagnostic without full solution scaffolding.',
 'pandas_fundamentals_001'),

('DATA_QUALITY', 3.0, 2.0, 'medium', 'diagnostic_pending',
 'Evidence from invalid-value checks, missing reference checks, sale-date checks, duplicate-style validation, and synthetic-data limitations.',
 'Needs independent data-quality diagnostic with messy data and reconciliation checks.',
 'sql_independence_001'),

('REPORTING', 3.0, 2.5, 'medium', 'diagnostic_pending',
 'Evidence from CSV reports, revenue summaries, charts, and written observations.',
 'Needs stronger spreadsheet/BI reporting diagnostic with pivot tables, charts, and metric interpretation.',
 'spreadsheet_reporting_001'),

('VISUALIZATION', 2.5, 1.5, 'low', 'diagnostic_pending',
 'Evidence from matplotlib charts and Plotly geospatial visualizations.',
 'Needs chart selection, chart interpretation, and dashboard-style reporting practice.',
 'spreadsheet_reporting_001'),

('APIS_WEB_APPS', 2.5, 1.5, 'low', 'diagnostic_pending',
 'Evidence from FastAPI endpoints, JSON responses, Flask dashboard routes, and simple templates.',
 'Needs endpoint explanation, debugging, and small modification diagnostic.',
 NULL),

('ML', 2.5, 1.5, 'low', 'diagnostic_pending',
 'Evidence from scikit-learn classifier workflow, train/test split, metrics, confusion matrix, prediction probability, and joblib model persistence.',
 'Needs ML concept diagnostic focused on leakage, metrics, train/test split, and interpretation.',
 'ml_concepts_001'),

('SYNTHETIC_DATA', 3.0, 2.0, 'medium', 'diagnostic_pending',
 'Evidence from synthetic customers, sales, monitoring records, student records, dropout simulation, and weighted sampling.',
 'Needs clearer documentation of assumptions, distributions, and limitations.',
 NULL),

('GEOSPATIAL', 2.0, 1.0, 'low', 'diagnostic_pending',
 'Evidence from GeoPandas loading, CRS handling, geographic merging, and Plotly choropleth mapping.',
 'Needs independent geospatial cleanup and map explanation diagnostic.',
 NULL),

('WORKFLOW_TOOLS', 2.5, 1.5, 'low', 'diagnostic_pending',
 'Evidence from GitHub project organization, Docker Compose, Dockerfile exposure, Linux terminal usage, requirements files, and run scripts.',
 'Needs terminal/Git/Docker workflow diagnostic.',
 'workflow_tools_001'),

('DOCUMENTATION', 3.0, 2.5, 'medium', 'diagnostic_pending',
 'Evidence from README files, run instructions, project summaries, assumptions, limitations, and generated profile documents.',
 'Needs concise project documentation rewrite and runbook diagnostic.',
 'project_explanation_001'),

('PROJECT_REASONING', 3.0, 2.0, 'medium', 'diagnostic_pending',
 'Evidence from multiple project artifacts and ability to discuss file roles, data flow, and project limitations.',
 'Needs direct project explanation diagnostic using the commerce pipeline or another selected project.',
 'project_explanation_001'),

('ETL_PIPELINES', 3.0, 2.0, 'low', 'diagnostic_pending',
 'Evidence from raw-to-table loading, CSV exports, generated data, report creation, and script-based project workflows.',
 'Needs stronger ETL evidence: raw to bronze/silver/gold or raw to clean to report pipeline with validation and logging.',
 NULL),

('DATA_MODELING', 2.5, 1.5, 'low', 'diagnostic_pending',
 'Evidence from relational schema creation, primary keys, foreign keys, product/customer/sales structure, and basic relationships.',
 'Needs data modeling diagnostic covering grain, keys, normalization, facts/dimensions, and schema explanation.',
 NULL),

('BIG_DATA_DATA_LAKE', 0.0, 0.0, 'low', 'not_started',
 'No accepted evidence yet.',
 'Needs PySpark, Parquet, partitioning, and data lake layer evidence if this branch becomes active.',
 NULL),

('CLOUD_DATA_PLATFORMS', 0.0, 0.0, 'low', 'not_started',
 'No accepted evidence yet.',
 'Needs cloud storage/database/warehouse basics if this branch becomes active.',
 NULL),

('TESTING_DEBUGGING', 2.0, 1.0, 'low', 'diagnostic_pending',
 'Evidence from some error handling, validation checks, connection checks, and project debugging.',
 'Needs explicit tests, debugging notes, error tracing, and regression checks.',
 NULL),

('BUSINESS_ANALYSIS', 2.0, 1.5, 'low', 'diagnostic_pending',
 'Evidence from basic report interpretation and metric summaries.',
 'Needs stronger KPI interpretation, stakeholder-style questions, and business-rule translation.',
 NULL),

('MATH_STATS', 2.0, 1.0, 'low', 'diagnostic_pending',
 'Evidence from ML metrics exposure and ongoing math study.',
 'Needs practical statistics diagnostic for distributions, averages, variance, correlation, hypothesis testing basics, and model evaluation.',
 NULL),

('MLOPS', 1.0, 0.5, 'low', 'not_started',
 'Minimal evidence from joblib model persistence and Docker exposure.',
 'Needs model packaging, inference API, reproducibility, and monitoring basics if ML branch becomes active.',
 NULL),

('LINUX_SYSTEMS', 2.0, 1.5, 'low', 'diagnostic_pending',
 'Evidence from Linux terminal use, project execution, shell scripts, and environment handling.',
 'Needs practical file/process/permissions/command diagnostic.',
 'workflow_tools_001'),

('NETWORKING_SECURITY', 0.5, 0.0, 'low', 'not_started',
 'Minimal indirect exposure through APIs and local services.',
 'Needs HTTP, ports, environment variables, secrets, IAM/security basics if cloud branch becomes active.',
 NULL),

('CONTAINERS_CI_CD', 2.0, 1.0, 'low', 'diagnostic_pending',
 'Evidence from Dockerfile, Docker Compose, and project containerization exposure.',
 'Needs container build/run/debug and simple CI validation evidence.',
 'workflow_tools_001')
ON CONFLICT(skill_cluster_id) DO UPDATE SET
    artifact_rating = excluded.artifact_rating,
    reliability_rating = excluded.reliability_rating,
    confidence_level = excluded.confidence_level,
    rating_status = excluded.rating_status,
    evidence_summary = excluded.evidence_summary,
    current_limitations = excluded.current_limitations,
    next_diagnostic_id = excluded.next_diagnostic_id,
    updated_at = CURRENT_TIMESTAMP;

-- ============================================================
-- Optional: seed rating events from current state
-- This creates an audit baseline if no event exists yet.
-- ============================================================

INSERT INTO profile_rating_events
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, reason)
SELECT
    ps.skill_cluster_id,
    ps.artifact_rating,
    ps.reliability_rating,
    ps.confidence_level,
    ps.rating_status,
    'Initial current profile seed from existing project evidence.'
FROM profile_skill_state ps
WHERE NOT EXISTS (
    SELECT 1
    FROM profile_rating_events pre
    WHERE pre.skill_cluster_id = ps.skill_cluster_id
);

-- Link each profile state row to its latest event.
UPDATE profile_skill_state
SET last_event_id = (
    SELECT pre.id
    FROM profile_rating_events pre
    WHERE pre.skill_cluster_id = profile_skill_state.skill_cluster_id
    ORDER BY pre.created_at DESC, pre.id DESC
    LIMIT 1
);

-- ============================================================
-- View: current profile ratings
-- Simple readable current profile.
-- ============================================================

CREATE VIEW current_profile_ratings AS
SELECT
    ps.skill_cluster_id,
    sc.name AS skill_cluster_name,
    ps.artifact_rating,
    ps.reliability_rating,
    ps.confidence_level,
    ps.rating_status,
    ps.evidence_summary,
    ps.current_limitations,
    ps.next_diagnostic_id,
    ps.last_event_id,
    ps.updated_at
FROM profile_skill_state ps
JOIN skill_clusters sc
    ON sc.id = ps.skill_cluster_id
ORDER BY ps.skill_cluster_id;

-- ============================================================
-- View: current profile vs all active targets
-- Useful if several profession branches are active.
-- ============================================================

CREATE VIEW current_profile_vs_target AS
SELECT
    t.id AS target_id,
    t.name AS target_name,

    sc.id AS skill_cluster_id,
    sc.name AS skill_cluster_name,

    ps.artifact_rating,
    ps.reliability_rating,
    tt.target_reliability,

    ROUND(tt.target_reliability - COALESCE(ps.reliability_rating, 0), 2) AS reliability_gap,

    ps.confidence_level,
    ps.rating_status,
    tt.priority,

    ps.evidence_summary,
    ps.current_limitations,
    ps.next_diagnostic_id,
    ps.updated_at
FROM target_thresholds tt
JOIN targets t
    ON t.id = tt.target_id
JOIN skill_clusters sc
    ON sc.id = tt.skill_cluster_id
LEFT JOIN profile_skill_state ps
    ON ps.skill_cluster_id = tt.skill_cluster_id
WHERE t.status = 'active';

-- ============================================================
-- View: compact gap summary
-- Useful for deciding next evaluation.
-- ============================================================

CREATE VIEW current_profile_gap_summary AS
SELECT
    target_id,
    target_name,
    skill_cluster_id,
    skill_cluster_name,
    reliability_rating,
    target_reliability,
    reliability_gap,
    confidence_level,
    rating_status,
    priority,
    next_diagnostic_id
FROM current_profile_vs_target
WHERE target_id = 'strong_data_specialist_core'
ORDER BY
    CASE priority
        WHEN 'core' THEN 1
        WHEN 'secondary' THEN 2
        WHEN 'later' THEN 3
        ELSE 4
    END,
    reliability_gap DESC,
    skill_cluster_id;

COMMIT;
