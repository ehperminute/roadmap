PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- ============================================================
-- Add missing skill clusters for strong middle data target
-- Existing clusters from SKILL_MAP.md are not overwritten.
-- ============================================================

INSERT OR IGNORE INTO skill_clusters
(id, name, specific_skills, tools, active)
VALUES
('ETL_PIPELINES', 'ETL & Data Pipelines',
 'extraction, transformation, loading, batch jobs, incremental loads, pipeline reliability',
 'Python, SQL, Airflow, scripts', 1),

('DATA_MODELING', 'Data Modeling',
 'relational modeling, star schema, facts/dimensions, normalization, warehouse layers',
 'SQL, dbt, PostgreSQL, data warehouses', 1),

('BIG_DATA_DATA_LAKE', 'Big Data & Data Lake',
 'Spark jobs, PySpark transformations, Parquet, partitions, bronze/silver/gold layers',
 'PySpark, Spark, Hadoop, Databricks, Cloudera, Parquet', 1),

('CLOUD_DATA_PLATFORMS', 'Cloud Data Platforms',
 'object storage, managed databases, cloud warehouses, permissions basics',
 'AWS, Azure, GCP, Snowflake, BigQuery, Databricks', 1),

('TESTING_DEBUGGING', 'Testing & Debugging',
 'unit tests, data tests, error tracing, regression checks, logging',
 'pytest, SQL checks, logs', 1),

('BUSINESS_ANALYSIS', 'Business Analysis',
 'requirements, metrics, KPIs, stakeholder questions, process interpretation',
 'General', 1),

('MATH_STATS', 'Math & Statistics',
 'probability, distributions, hypothesis testing, linear algebra basics, model evaluation',
 'Python, statistics libraries', 1),

('MLOPS', 'ML Operations',
 'model packaging, inference APIs, monitoring basics, reproducibility',
 'MLflow, Docker, APIs, cloud', 1),

('LINUX_SYSTEMS', 'Linux & Systems',
 'shell, files, permissions, processes, services',
 'Linux, Bash', 1),

('NETWORKING_SECURITY', 'Networking & Security Basics',
 'HTTP, DNS, ports, IAM basics, secrets, access control',
 'Cloud consoles, Linux, GitHub', 1),

('CONTAINERS_CI_CD', 'Containers & CI/CD',
 'Dockerfiles, images, containers, pipelines, automated checks',
 'Docker, GitHub Actions', 1);

-- ============================================================
-- Profession-family targets
-- ============================================================

INSERT INTO targets (id, name, description, status)
VALUES
('strong_data_specialist_core',
 'Strong Data Specialist Core',
 'Final general target: strong middle-level data specialist foundation across SQL, Python data work, data quality, reporting, ETL, data modeling, workflow, documentation, and project reasoning.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

INSERT INTO targets (id, name, description, status)
VALUES
('data_analyst_bi',
 'Data Analyst / BI Analyst',
 'Branch profile focused on SQL, reporting, BI tools, visualization, business interpretation, and data quality.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

INSERT INTO targets (id, name, description, status)
VALUES
('data_scientist',
 'Data Scientist',
 'Branch profile focused on statistics, machine learning, Python data work, SQL, experimentation, visualization, and business interpretation.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

INSERT INTO targets (id, name, description, status)
VALUES
('data_engineer',
 'Data Engineer',
 'Branch profile focused on ETL pipelines, SQL, Python, data modeling, workflow tools, cloud platforms, big data, and debugging.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

INSERT INTO targets (id, name, description, status)
VALUES
('analytics_engineer',
 'Analytics Engineer',
 'Branch profile focused on SQL, data modeling, dbt-style transformations, testing, documentation, analytics layers, and BI support.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

INSERT INTO targets (id, name, description, status)
VALUES
('ai_ml_engineer',
 'AI / ML Engineer',
 'Branch profile focused on machine learning systems, model evaluation, APIs, deployment, testing, MLOps, and cloud-adjacent workflows.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

INSERT INTO targets (id, name, description, status)
VALUES
('cloud_engineer',
 'Cloud Engineer',
 'Branch profile focused on cloud platforms, Linux, networking, security, containers, CI/CD, automation, and operational reliability.',
 'active')
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = datetime('now');

-- ============================================================
-- Avoid duplicate threshold rows before inserting matrix
-- ============================================================

DELETE FROM target_thresholds
WHERE target_id IN (
    'strong_data_specialist_core',
    'data_analyst_bi',
    'data_scientist',
    'data_engineer',
    'analytics_engineer',
    'ai_ml_engineer',
    'cloud_engineer'
);

-- ============================================================
-- Strong Data Specialist Core
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('strong_data_specialist_core', 'SQL_DATABASES', 6, 'core', 'Strong middle-level SQL foundation.'),
('strong_data_specialist_core', 'PYTHON_DATA_WORK', 6, 'core', 'Strong practical Python data work.'),
('strong_data_specialist_core', 'DATA_QUALITY', 6, 'core', 'Strong data validation and reliability practices.'),
('strong_data_specialist_core', 'REPORTING', 5, 'core', 'Practical reporting and BI output.'),
('strong_data_specialist_core', 'VISUALIZATION', 5, 'core', 'Practical charting and interpretation.'),
('strong_data_specialist_core', 'APIS_WEB_APPS', 4, 'secondary', 'Useful for data applications and service integration.'),
('strong_data_specialist_core', 'ML', 4, 'secondary', 'Useful ML literacy and applied workflow.'),
('strong_data_specialist_core', 'SYNTHETIC_DATA', 4, 'secondary', 'Useful for testing, simulation, and portfolio data.'),
('strong_data_specialist_core', 'GEOSPATIAL', 3, 'secondary', 'Optional applied specialization.'),
('strong_data_specialist_core', 'WORKFLOW_TOOLS', 5, 'core', 'Git, terminal, Docker, and project execution.'),
('strong_data_specialist_core', 'DOCUMENTATION', 5, 'core', 'Readable documentation, runbooks, assumptions, limitations.'),
('strong_data_specialist_core', 'PROJECT_REASONING', 6, 'core', 'Can explain systems, files, data flow, and tradeoffs.'),
('strong_data_specialist_core', 'ETL_PIPELINES', 6, 'core', 'Build reliable raw-to-clean data workflows.'),
('strong_data_specialist_core', 'DATA_MODELING', 6, 'core', 'Understand schemas, grain, keys, and warehouse-style modeling.'),
('strong_data_specialist_core', 'BIG_DATA_DATA_LAKE', 4, 'secondary', 'Useful data lake / Spark foundation.'),
('strong_data_specialist_core', 'CLOUD_DATA_PLATFORMS', 4, 'secondary', 'Cloud data platform literacy.'),
('strong_data_specialist_core', 'TESTING_DEBUGGING', 5, 'core', 'Debugging, validation, and regression checks.'),
('strong_data_specialist_core', 'BUSINESS_ANALYSIS', 5, 'core', 'Metrics, requirements, and business interpretation.'),
('strong_data_specialist_core', 'MATH_STATS', 4, 'secondary', 'Statistics and model evaluation literacy.'),
('strong_data_specialist_core', 'MLOPS', 3, 'later', 'Useful later for ML deployment branch.'),
('strong_data_specialist_core', 'LINUX_SYSTEMS', 4, 'secondary', 'Linux and shell competence.'),
('strong_data_specialist_core', 'NETWORKING_SECURITY', 3, 'later', 'Basic networking/security literacy.'),
('strong_data_specialist_core', 'CONTAINERS_CI_CD', 4, 'secondary', 'Containers and automated checks.');

-- ============================================================
-- Data Analyst / BI Analyst
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('data_analyst_bi', 'SQL_DATABASES', 6, 'core', NULL),
('data_analyst_bi', 'PYTHON_DATA_WORK', 4, 'secondary', NULL),
('data_analyst_bi', 'DATA_QUALITY', 5, 'core', NULL),
('data_analyst_bi', 'REPORTING', 6, 'core', NULL),
('data_analyst_bi', 'VISUALIZATION', 6, 'core', NULL),
('data_analyst_bi', 'APIS_WEB_APPS', 2, 'later', NULL),
('data_analyst_bi', 'ML', 2, 'later', NULL),
('data_analyst_bi', 'SYNTHETIC_DATA', 3, 'secondary', NULL),
('data_analyst_bi', 'GEOSPATIAL', 2, 'later', NULL),
('data_analyst_bi', 'WORKFLOW_TOOLS', 3, 'secondary', NULL),
('data_analyst_bi', 'DOCUMENTATION', 4, 'core', NULL),
('data_analyst_bi', 'PROJECT_REASONING', 5, 'core', NULL),
('data_analyst_bi', 'ETL_PIPELINES', 3, 'secondary', NULL),
('data_analyst_bi', 'DATA_MODELING', 4, 'secondary', NULL),
('data_analyst_bi', 'BIG_DATA_DATA_LAKE', 1, 'later', NULL),
('data_analyst_bi', 'CLOUD_DATA_PLATFORMS', 2, 'later', NULL),
('data_analyst_bi', 'TESTING_DEBUGGING', 3, 'secondary', NULL),
('data_analyst_bi', 'BUSINESS_ANALYSIS', 6, 'core', NULL),
('data_analyst_bi', 'MATH_STATS', 4, 'secondary', NULL),
('data_analyst_bi', 'MLOPS', 0, 'later', NULL),
('data_analyst_bi', 'LINUX_SYSTEMS', 2, 'later', NULL),
('data_analyst_bi', 'NETWORKING_SECURITY', 1, 'later', NULL),
('data_analyst_bi', 'CONTAINERS_CI_CD', 1, 'later', NULL);

-- ============================================================
-- Data Scientist
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('data_scientist', 'SQL_DATABASES', 6, 'core', NULL),
('data_scientist', 'PYTHON_DATA_WORK', 6, 'core', NULL),
('data_scientist', 'DATA_QUALITY', 5, 'core', NULL),
('data_scientist', 'REPORTING', 5, 'core', NULL),
('data_scientist', 'VISUALIZATION', 6, 'core', NULL),
('data_scientist', 'APIS_WEB_APPS', 3, 'secondary', NULL),
('data_scientist', 'ML', 6, 'core', NULL),
('data_scientist', 'SYNTHETIC_DATA', 5, 'secondary', NULL),
('data_scientist', 'GEOSPATIAL', 3, 'secondary', NULL),
('data_scientist', 'WORKFLOW_TOOLS', 5, 'core', NULL),
('data_scientist', 'DOCUMENTATION', 5, 'core', NULL),
('data_scientist', 'PROJECT_REASONING', 6, 'core', NULL),
('data_scientist', 'ETL_PIPELINES', 4, 'secondary', NULL),
('data_scientist', 'DATA_MODELING', 5, 'secondary', NULL),
('data_scientist', 'BIG_DATA_DATA_LAKE', 4, 'secondary', NULL),
('data_scientist', 'CLOUD_DATA_PLATFORMS', 4, 'secondary', NULL),
('data_scientist', 'TESTING_DEBUGGING', 4, 'secondary', NULL),
('data_scientist', 'BUSINESS_ANALYSIS', 6, 'core', NULL),
('data_scientist', 'MATH_STATS', 6, 'core', NULL),
('data_scientist', 'MLOPS', 3, 'secondary', NULL),
('data_scientist', 'LINUX_SYSTEMS', 3, 'secondary', NULL),
('data_scientist', 'NETWORKING_SECURITY', 2, 'later', NULL),
('data_scientist', 'CONTAINERS_CI_CD', 3, 'secondary', NULL);

-- ============================================================
-- Data Engineer
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('data_engineer', 'SQL_DATABASES', 6, 'core', NULL),
('data_engineer', 'PYTHON_DATA_WORK', 6, 'core', NULL),
('data_engineer', 'DATA_QUALITY', 6, 'core', NULL),
('data_engineer', 'REPORTING', 3, 'secondary', NULL),
('data_engineer', 'VISUALIZATION', 3, 'secondary', NULL),
('data_engineer', 'APIS_WEB_APPS', 4, 'secondary', NULL),
('data_engineer', 'ML', 2, 'later', NULL),
('data_engineer', 'SYNTHETIC_DATA', 4, 'secondary', NULL),
('data_engineer', 'GEOSPATIAL', 2, 'later', NULL),
('data_engineer', 'WORKFLOW_TOOLS', 6, 'core', NULL),
('data_engineer', 'DOCUMENTATION', 5, 'core', NULL),
('data_engineer', 'PROJECT_REASONING', 6, 'core', NULL),
('data_engineer', 'ETL_PIPELINES', 7, 'core', NULL),
('data_engineer', 'DATA_MODELING', 6, 'core', NULL),
('data_engineer', 'BIG_DATA_DATA_LAKE', 6, 'core', NULL),
('data_engineer', 'CLOUD_DATA_PLATFORMS', 5, 'core', NULL),
('data_engineer', 'TESTING_DEBUGGING', 6, 'core', NULL),
('data_engineer', 'BUSINESS_ANALYSIS', 4, 'secondary', NULL),
('data_engineer', 'MATH_STATS', 2, 'later', NULL),
('data_engineer', 'MLOPS', 3, 'secondary', NULL),
('data_engineer', 'LINUX_SYSTEMS', 5, 'core', NULL),
('data_engineer', 'NETWORKING_SECURITY', 3, 'secondary', NULL),
('data_engineer', 'CONTAINERS_CI_CD', 5, 'core', NULL);

-- ============================================================
-- Analytics Engineer
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('analytics_engineer', 'SQL_DATABASES', 7, 'core', NULL),
('analytics_engineer', 'PYTHON_DATA_WORK', 5, 'core', NULL),
('analytics_engineer', 'DATA_QUALITY', 6, 'core', NULL),
('analytics_engineer', 'REPORTING', 5, 'core', NULL),
('analytics_engineer', 'VISUALIZATION', 4, 'secondary', NULL),
('analytics_engineer', 'APIS_WEB_APPS', 3, 'secondary', NULL),
('analytics_engineer', 'ML', 3, 'secondary', NULL),
('analytics_engineer', 'SYNTHETIC_DATA', 4, 'secondary', NULL),
('analytics_engineer', 'GEOSPATIAL', 2, 'later', NULL),
('analytics_engineer', 'WORKFLOW_TOOLS', 5, 'core', NULL),
('analytics_engineer', 'DOCUMENTATION', 6, 'core', NULL),
('analytics_engineer', 'PROJECT_REASONING', 6, 'core', NULL),
('analytics_engineer', 'ETL_PIPELINES', 6, 'core', NULL),
('analytics_engineer', 'DATA_MODELING', 7, 'core', NULL),
('analytics_engineer', 'BIG_DATA_DATA_LAKE', 4, 'secondary', NULL),
('analytics_engineer', 'CLOUD_DATA_PLATFORMS', 4, 'secondary', NULL),
('analytics_engineer', 'TESTING_DEBUGGING', 5, 'core', NULL),
('analytics_engineer', 'BUSINESS_ANALYSIS', 5, 'core', NULL),
('analytics_engineer', 'MATH_STATS', 3, 'secondary', NULL),
('analytics_engineer', 'MLOPS', 2, 'later', NULL),
('analytics_engineer', 'LINUX_SYSTEMS', 4, 'secondary', NULL),
('analytics_engineer', 'NETWORKING_SECURITY', 2, 'later', NULL),
('analytics_engineer', 'CONTAINERS_CI_CD', 4, 'secondary', NULL);

-- ============================================================
-- AI / ML Engineer
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('ai_ml_engineer', 'SQL_DATABASES', 4, 'secondary', NULL),
('ai_ml_engineer', 'PYTHON_DATA_WORK', 6, 'core', NULL),
('ai_ml_engineer', 'DATA_QUALITY', 5, 'core', NULL),
('ai_ml_engineer', 'REPORTING', 3, 'secondary', NULL),
('ai_ml_engineer', 'VISUALIZATION', 4, 'secondary', NULL),
('ai_ml_engineer', 'APIS_WEB_APPS', 5, 'core', NULL),
('ai_ml_engineer', 'ML', 6, 'core', NULL),
('ai_ml_engineer', 'SYNTHETIC_DATA', 5, 'secondary', NULL),
('ai_ml_engineer', 'GEOSPATIAL', 2, 'later', NULL),
('ai_ml_engineer', 'WORKFLOW_TOOLS', 5, 'core', NULL),
('ai_ml_engineer', 'DOCUMENTATION', 5, 'core', NULL),
('ai_ml_engineer', 'PROJECT_REASONING', 6, 'core', NULL),
('ai_ml_engineer', 'ETL_PIPELINES', 4, 'secondary', NULL),
('ai_ml_engineer', 'DATA_MODELING', 4, 'secondary', NULL),
('ai_ml_engineer', 'BIG_DATA_DATA_LAKE', 4, 'secondary', NULL),
('ai_ml_engineer', 'CLOUD_DATA_PLATFORMS', 5, 'core', NULL),
('ai_ml_engineer', 'TESTING_DEBUGGING', 6, 'core', NULL),
('ai_ml_engineer', 'BUSINESS_ANALYSIS', 4, 'secondary', NULL),
('ai_ml_engineer', 'MATH_STATS', 5, 'core', NULL),
('ai_ml_engineer', 'MLOPS', 6, 'core', NULL),
('ai_ml_engineer', 'LINUX_SYSTEMS', 4, 'secondary', NULL),
('ai_ml_engineer', 'NETWORKING_SECURITY', 3, 'secondary', NULL),
('ai_ml_engineer', 'CONTAINERS_CI_CD', 5, 'core', NULL);

-- ============================================================
-- Cloud Engineer
-- ============================================================

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('cloud_engineer', 'SQL_DATABASES', 3, 'secondary', NULL),
('cloud_engineer', 'PYTHON_DATA_WORK', 4, 'secondary', NULL),
('cloud_engineer', 'DATA_QUALITY', 4, 'secondary', NULL),
('cloud_engineer', 'REPORTING', 2, 'later', NULL),
('cloud_engineer', 'VISUALIZATION', 2, 'later', NULL),
('cloud_engineer', 'APIS_WEB_APPS', 3, 'secondary', NULL),
('cloud_engineer', 'ML', 2, 'later', NULL),
('cloud_engineer', 'SYNTHETIC_DATA', 2, 'later', NULL),
('cloud_engineer', 'GEOSPATIAL', 0, 'later', NULL),
('cloud_engineer', 'WORKFLOW_TOOLS', 6, 'core', NULL),
('cloud_engineer', 'DOCUMENTATION', 5, 'core', NULL),
('cloud_engineer', 'PROJECT_REASONING', 6, 'core', NULL),
('cloud_engineer', 'ETL_PIPELINES', 4, 'secondary', NULL),
('cloud_engineer', 'DATA_MODELING', 3, 'secondary', NULL),
('cloud_engineer', 'BIG_DATA_DATA_LAKE', 3, 'secondary', NULL),
('cloud_engineer', 'CLOUD_DATA_PLATFORMS', 7, 'core', NULL),
('cloud_engineer', 'TESTING_DEBUGGING', 6, 'core', NULL),
('cloud_engineer', 'BUSINESS_ANALYSIS', 3, 'secondary', NULL),
('cloud_engineer', 'MATH_STATS', 1, 'later', NULL),
('cloud_engineer', 'MLOPS', 4, 'secondary', NULL),
('cloud_engineer', 'LINUX_SYSTEMS', 6, 'core', NULL),
('cloud_engineer', 'NETWORKING_SECURITY', 6, 'core', NULL),
('cloud_engineer', 'CONTAINERS_CI_CD', 6, 'core', NULL);

COMMIT;
