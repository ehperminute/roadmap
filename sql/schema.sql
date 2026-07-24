PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- ============================================================
-- Rating scale
-- ============================================================

CREATE TABLE IF NOT EXISTS scale_levels (
    score INTEGER PRIMARY KEY CHECK (score BETWEEN 0 AND 10),
    meaning TEXT NOT NULL
);

INSERT OR IGNORE INTO scale_levels (score, meaning)
VALUES
(0, 'No accepted evidence.'),
(1, 'Minimal exposure.'),
(2, 'Can follow with heavy help.'),
(3, 'Can complete simple work with guidance.'),
(4, 'Can complete basic work with limited help.'),
(5, 'Practical working competence in familiar tasks.'),
(6, 'Strong middle-level reliability for common tasks.'),
(7, 'Advanced practical competence.'),
(8, 'Strong independent competence across varied tasks.'),
(9, 'Expert-level reliability.'),
(10, 'Reference-level mastery.');

-- ============================================================
-- Skill taxonomy
-- ============================================================

CREATE TABLE IF NOT EXISTS skill_clusters (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    specific_skills TEXT NOT NULL,
    tools TEXT,
    active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO skill_clusters
(id, name, specific_skills, tools, active)
VALUES
('SQL_DATABASES', 'SQL & Databases',
 'SELECT, WHERE, ORDER BY, JOIN, GROUP BY, aggregation, date grouping, validation queries, schema basics',
 'PostgreSQL, SQLite, SQL', 1),

('PYTHON_DATA_WORK', 'Python Data Work',
 'scripting, functions, CSV handling, data generation, cleaning, grouping, aggregation, export',
 'Python, pandas, NumPy', 1),

('DATA_QUALITY', 'Data Quality',
 'invalid values, missing references, duplicate detection, allowed values, date consistency, quality checks',
 'SQL, pandas, PostgreSQL', 1),

('REPORTING', 'Reporting & BI',
 'CSV reports, pivot tables, charts, written observations, synthetic-data limitation notes',
 'Excel, Google Sheets, Power BI, Looker Studio, CSV', 1),

('VISUALIZATION', 'Data Visualization',
 'bar charts, line charts, maps, dashboard visuals, chart interpretation',
 'matplotlib, Plotly, Sheets, Power BI', 1),

('APIS_WEB_APPS', 'APIs & Web Apps',
 'API endpoints, JSON responses, web routes, templates, simple dashboards',
 'FastAPI, Flask, HTML', 1),

('ML', 'Machine Learning',
 'train/test split, baseline, classifier training, metrics, confusion matrix, prediction probability, leakage awareness',
 'scikit-learn, pandas, joblib', 1),

('SYNTHETIC_DATA', 'Synthetic Data',
 'simulated records, weighted sampling, generated time series/panels, scenario assumptions',
 'Python, NumPy, pandas, Faker', 1),

('GEOSPATIAL', 'Geospatial Analytics',
 'geometry loading, CRS conversion, spatial joins/merges, choropleth maps, geographic aggregation',
 'GeoPandas, Shapely, Plotly', 1),

('WORKFLOW_TOOLS', 'Workflow Tools',
 'running scripts, environment setup, containers, Git basics, terminal commands, project execution',
 'Git, GitHub, Docker, Docker Compose, Linux terminal', 1),

('DOCUMENTATION', 'Documentation',
 'README, run instructions, input/output description, assumptions, limitations',
 'Markdown', 1),

('PROJECT_REASONING', 'Project Reasoning',
 'file/function explanation, workflow tracing, dependency awareness, debugging explanation',
 'General', 1);

-- ============================================================
-- Raw artifacts and history export queue
-- ============================================================

CREATE TABLE IF NOT EXISTS raw_artifacts (
    id TEXT PRIMARY KEY,
    artifact_type TEXT NOT NULL,
    source_name TEXT NOT NULL,
    source_path TEXT,
    content TEXT NOT NULL,
    content_hash TEXT,
    notes TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS artifact_export_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    raw_artifact_id TEXT NOT NULL,
    export_path TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'exported', 'failed')),
    error_message TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    exported_at TEXT,

    FOREIGN KEY (raw_artifact_id) REFERENCES raw_artifacts(id)
);

CREATE TRIGGER IF NOT EXISTS trg_raw_artifact_export_insert
AFTER INSERT ON raw_artifacts
BEGIN
    INSERT INTO artifact_export_queue (raw_artifact_id, export_path, status)
    VALUES (NEW.id, 'history/' || NEW.id || '.txt', 'pending');
END;

CREATE TRIGGER IF NOT EXISTS trg_raw_artifact_export_update
AFTER UPDATE OF content ON raw_artifacts
BEGIN
    INSERT INTO artifact_export_queue (raw_artifact_id, export_path, status)
    VALUES (NEW.id, 'history/' || NEW.id || '.txt', 'pending');
END;

-- ============================================================
-- Projects
-- ============================================================

CREATE TABLE IF NOT EXISTS projects (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    summary TEXT,
    status TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'archived', 'draft')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS project_artifacts (
    project_id TEXT NOT NULL,
    raw_artifact_id TEXT NOT NULL,
    relationship TEXT NOT NULL DEFAULT 'source',

    PRIMARY KEY (project_id, raw_artifact_id),

    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (raw_artifact_id) REFERENCES raw_artifacts(id)
);

CREATE TABLE IF NOT EXISTS project_skill_evidence (
    project_id TEXT NOT NULL,
    skill_cluster_id TEXT NOT NULL,
    evidence_summary TEXT,
    evidence_status TEXT NOT NULL DEFAULT 'artifact_baseline_accepted',

    PRIMARY KEY (project_id, skill_cluster_id),

    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id)
);

INSERT OR IGNORE INTO projects (id, name, summary, status)
VALUES
('commerce_pipeline', 'Commerce Pipeline',
 'Python/PostgreSQL commerce reporting pipeline with synthetic data, SQL analytics, quality checks, CSV exports, charts, and Docker Compose.',
 'active'),

('fastapi_postgres_stats', 'FastAPI PostgreSQL Stats API',
 'FastAPI app with PostgreSQL connection, SQL aggregation endpoints, JSON responses, Docker Compose, and run scripts.',
 'active'),

('cattle_monitor', 'Cattle Monitor',
 'Flask dashboard using pandas, NumPy, scikit-learn classifier workflow, joblib model persistence, prediction probabilities, and Dockerfile.',
 'active'),

('synthetic_geo_cdmx', 'Synthetic Geo Data CDMX',
 'Synthetic student/dropout/geospatial workflow using SQLite, GeoPandas, CRS handling, geographic joins, and Plotly mapping.',
 'active');

-- ============================================================
-- Evidence items
-- ============================================================

CREATE TABLE IF NOT EXISTS evidence_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    evidence_type TEXT NOT NULL,
    summary TEXT,
    project_id TEXT,
    raw_artifact_id TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (raw_artifact_id) REFERENCES raw_artifacts(id)
);

CREATE TABLE IF NOT EXISTS evidence_skill_clusters (
    evidence_item_id INTEGER NOT NULL,
    skill_cluster_id TEXT NOT NULL,

    PRIMARY KEY (evidence_item_id, skill_cluster_id),

    FOREIGN KEY (evidence_item_id) REFERENCES evidence_items(id),
    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id)
);

-- ============================================================
-- Targets
-- ============================================================

CREATE TABLE IF NOT EXISTS targets (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'draft'
        CHECK (status IN ('active', 'archived', 'draft')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS target_thresholds (
    target_id TEXT NOT NULL,
    skill_cluster_id TEXT NOT NULL,
    target_reliability REAL NOT NULL CHECK (target_reliability BETWEEN 0 AND 10),
    priority TEXT NOT NULL CHECK (
        priority IN ('core', 'secondary', 'later', 'optional')
    ),
    notes TEXT,

    PRIMARY KEY (target_id, skill_cluster_id),

    FOREIGN KEY (target_id) REFERENCES targets(id),
    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id)
);

-- ============================================================
-- Diagnostics and attempts
-- ============================================================

CREATE TABLE IF NOT EXISTS diagnostics (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    target_id TEXT,
    status TEXT NOT NULL DEFAULT 'planned'
        CHECK (status IN ('planned', 'active', 'passed', 'failed', 'archived')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (target_id) REFERENCES targets(id)
);




CREATE TABLE IF NOT EXISTS diagnostic_skill_clusters (
    diagnostic_id TEXT NOT NULL,
    skill_cluster_id TEXT NOT NULL,

    PRIMARY KEY (diagnostic_id, skill_cluster_id),

    FOREIGN KEY (diagnostic_id) REFERENCES diagnostics(id),
    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id)
);






CREATE TABLE IF NOT EXISTS diagnostic_attempts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    diagnostic_id TEXT NOT NULL,
    attempt_key TEXT,

    attempt_summary TEXT,
    submission_text TEXT,

    result TEXT CHECK (result IN ('passed', 'failed', 'partial', 'not_scored')),
    score REAL CHECK (score BETWEEN 0 AND 10),

    assistance_level TEXT NOT NULL DEFAULT 'not_recorded'
        CHECK (
            assistance_level IN (
                'independent',
                'assisted_acknowledged',
                'minor_hint',
                'guided',
                'solution_reviewed',
                'not_recorded'
            )
        ),

    evaluator_notes TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (diagnostic_id) REFERENCES diagnostics(id),

    UNIQUE (diagnostic_id, attempt_key)
);

CREATE TABLE IF NOT EXISTS diagnostic_skill_results (
    diagnostic_attempt_id INTEGER NOT NULL,
    skill_cluster_id TEXT NOT NULL,
    result TEXT NOT NULL CHECK (result IN ('passed', 'failed', 'partial', 'not_scored')),
    score REAL CHECK (score BETWEEN 0 AND 10),
    notes TEXT,

    PRIMARY KEY (diagnostic_attempt_id, skill_cluster_id),

    FOREIGN KEY (diagnostic_attempt_id) REFERENCES diagnostic_attempts(id),
    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id)
);

INSERT OR IGNORE INTO diagnostics (id, name, description, status)
VALUES
('project_explanation_001',
 'Project Explanation Diagnostic',
 'Explain project structure, files, data flow, assumptions, limitations, and debugging points.',
 'planned'),

('sql_independence_001',
 'SQL Independence Diagnostic',
 'Write and explain SQL queries involving joins, aggregation, date grouping, validation checks, and data-quality logic.',
 'planned'),

('pandas_fundamentals_001',
 'pandas Fundamentals Diagnostic',
 'Clean, transform, aggregate, and export data using pandas without full solution scaffolding.',
 'planned'),

('spreadsheet_reporting_001',
 'Spreadsheet Reporting Diagnostic',
 'Create pivot-style summaries, charts, and written observations from tabular data.',
 'planned'),

('workflow_tools_001',
 'Workflow Tools Diagnostic',
 'Use terminal, Git, project files, Docker basics, and error interpretation in a practical workflow.',
 'planned'),

('ml_concepts_001',
 'ML Concepts Diagnostic',
 'Explain train/test split, leakage, metrics, confusion matrix, probability, and basic model interpretation.',
 'planned');

-- ============================================================
-- Modules, tasks, and current context
-- ============================================================

CREATE TABLE IF NOT EXISTS modules (
    id TEXT PRIMARY KEY,
    target_id TEXT,
    name TEXT NOT NULL,
    objective TEXT,
    status TEXT NOT NULL DEFAULT 'planned'
        CHECK (status IN ('planned', 'active', 'completed', 'archived')),
    exit_criteria TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (target_id) REFERENCES targets(id)
);

CREATE TABLE IF NOT EXISTS module_diagnostics (
    module_id TEXT NOT NULL,
    diagnostic_id TEXT NOT NULL,

    PRIMARY KEY (module_id, diagnostic_id),

    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (diagnostic_id) REFERENCES diagnostics(id)
);

CREATE TABLE IF NOT EXISTS tasks (
    id TEXT PRIMARY KEY,
    module_id TEXT,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'planned'
        CHECK (status IN ('planned', 'active', 'completed', 'blocked', 'archived')),
    due_order INTEGER,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (module_id) REFERENCES modules(id)
);

CREATE TABLE IF NOT EXISTS current_context (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    active_target_id TEXT,
    active_module_id TEXT,
    active_task_id TEXT,
    active_diagnostic_id TEXT,
    current_focus TEXT,
    next_action TEXT,
    blocker TEXT,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (active_target_id) REFERENCES targets(id),
    FOREIGN KEY (active_module_id) REFERENCES modules(id),
    FOREIGN KEY (active_task_id) REFERENCES tasks(id),
    FOREIGN KEY (active_diagnostic_id) REFERENCES diagnostics(id)
);

INSERT OR IGNORE INTO current_context
(id, current_focus, next_action, blocker)
VALUES
(1, 'Bootstrap roadmap database.', 'Create target profiles and current profile state.', NULL);

-- ============================================================
-- Market signals
-- ============================================================

CREATE TABLE IF NOT EXISTS market_probes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_name TEXT,
    role_title TEXT NOT NULL,
    role_family TEXT,
    summary TEXT,
    raw_text TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS market_skill_signals (
    market_probe_id INTEGER NOT NULL,
    skill_cluster_id TEXT NOT NULL,
    signal_strength TEXT NOT NULL CHECK (
        signal_strength IN ('low', 'medium', 'high')
    ),
    notes TEXT,

    PRIMARY KEY (market_probe_id, skill_cluster_id),

    FOREIGN KEY (market_probe_id) REFERENCES market_probes(id),
    FOREIGN KEY (skill_cluster_id) REFERENCES skill_clusters(id)
);

-- ============================================================
-- Generated documents
-- ============================================================

CREATE TABLE IF NOT EXISTS generated_documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    document_name TEXT NOT NULL,
    document_path TEXT NOT NULL,
    source_query TEXT,
    generated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMIT;
