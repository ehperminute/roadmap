PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- ============================================================
-- New skill clusters for Applied AI Software Engineer branch
-- ============================================================

INSERT OR IGNORE INTO skill_clusters
(id, name, specific_skills, tools, active)
VALUES
('JAVA_BACKEND', 'Java Backend',
 'Java fundamentals, OOP, backend services, API logic, service-layer code',
 'Java, Spring-style backend concepts', 1),

('FRONTEND_APPS', 'Frontend Applications',
 'frontend interfaces, forms, state, API consumption, basic UI workflows',
 'HTML, CSS, JavaScript, React or similar frameworks', 1),

('LLM_APP_ENGINEERING', 'LLM Application Engineering',
 'LLM API usage, prompt workflows, tool/function calling, structured outputs, retrieval-aware app logic',
 'OpenAI API, Claude API, LangChain-style tools, JSON', 1),

('AGENTIC_WORKFLOWS', 'Agentic Workflows',
 'multi-step AI workflows, tool use, task routing, validation loops, human-in-the-loop patterns',
 'LLM agents, workflow orchestration, APIs', 1),

('SYSTEM_INTEGRATION', 'System Integration',
 'API integrations, JSON contracts, internal systems, data exchange, error handling across services',
 'REST APIs, JSON, webhooks, enterprise systems', 1),

('AI_ASSISTED_DEVELOPMENT', 'AI-Assisted Development',
 'using AI coding tools, reviewing generated code, debugging AI output, accelerating implementation safely',
 'Cursor, Claude Code, ChatGPT, GitHub Copilot', 1),

('EVENT_DRIVEN_SYSTEMS', 'Event-Driven Systems',
 'events, queues, async workflows, producers/consumers, integration patterns',
 'Redis, message queues, webhooks, event buses', 1);

-- ============================================================
-- New profession branch target
-- ============================================================

INSERT INTO targets (id, name, description, status)
VALUES (
    'applied_ai_software_engineer',
    'Applied AI Software Engineer',
    'Future branch profile focused on building production AI-enabled applications: backend services, APIs, frontend interfaces, LLM workflows, system integrations, testing, CI/CD, and AI-assisted development.',
    'active'
)
ON CONFLICT(id) DO UPDATE SET
    name = excluded.name,
    description = excluded.description,
    status = excluded.status,
    updated_at = CURRENT_TIMESTAMP;

-- Replace thresholds for this target only
DELETE FROM target_thresholds
WHERE target_id = 'applied_ai_software_engineer';

INSERT INTO target_thresholds
(target_id, skill_cluster_id, target_reliability, priority, notes)
VALUES
('applied_ai_software_engineer', 'PYTHON_DATA_WORK', 6, 'core', 'Python for backend services, automation, AI workflows, and data handling.'),
('applied_ai_software_engineer', 'JAVA_BACKEND', 5, 'core', 'Java fundamentals and backend service implementation.'),
('applied_ai_software_engineer', 'FRONTEND_APPS', 4, 'secondary', 'Basic frontend ability for fullstack AI tools.'),
('applied_ai_software_engineer', 'APIS_WEB_APPS', 6, 'core', 'APIs, backend services, JSON responses, and application interfaces.'),
('applied_ai_software_engineer', 'LLM_APP_ENGINEERING', 6, 'core', 'LLM-powered workflows, structured outputs, and tool/function calling.'),
('applied_ai_software_engineer', 'AGENTIC_WORKFLOWS', 5, 'core', 'Multi-step AI workflows and agent-like task execution.'),
('applied_ai_software_engineer', 'SYSTEM_INTEGRATION', 6, 'core', 'Connecting internal systems through APIs and integration logic.'),
('applied_ai_software_engineer', 'EVENT_DRIVEN_SYSTEMS', 4, 'secondary', 'Event-driven and async integration patterns.'),
('applied_ai_software_engineer', 'AI_ASSISTED_DEVELOPMENT', 6, 'core', 'Effective use and verification of AI-assisted coding tools.'),
('applied_ai_software_engineer', 'TESTING_DEBUGGING', 6, 'core', 'Production-quality code, debugging, automated validation.'),
('applied_ai_software_engineer', 'WORKFLOW_TOOLS', 5, 'core', 'Git, terminal, project execution, development workflow.'),
('applied_ai_software_engineer', 'CONTAINERS_CI_CD', 5, 'core', 'Docker, CI/CD, automated checks, deployable services.'),
('applied_ai_software_engineer', 'CLOUD_DATA_PLATFORMS', 4, 'secondary', 'Azure/cloud exposure for deployment and integrations.'),
('applied_ai_software_engineer', 'DOCUMENTATION', 5, 'core', 'Runbooks, API docs, assumptions, implementation notes.'),
('applied_ai_software_engineer', 'PROJECT_REASONING', 6, 'core', 'Requirements-to-code reasoning, ownership, system explanation.'),
('applied_ai_software_engineer', 'SQL_DATABASES', 4, 'secondary', 'Database-backed applications and persistence.'),
('applied_ai_software_engineer', 'DATA_QUALITY', 3, 'secondary', 'Validation and correctness checks in AI/data workflows.'),
('applied_ai_software_engineer', 'ML', 3, 'secondary', 'ML literacy; not the main focus of this branch.'),
('applied_ai_software_engineer', 'MLOPS', 3, 'secondary', 'Basic deployment/reproducibility awareness for AI systems.');

-- ============================================================
-- Seed current profile rows for new skill clusters only
-- Do not overwrite future evaluated ratings.
-- ============================================================

INSERT OR IGNORE INTO profile_skill_state
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, evidence_summary, current_limitations, next_diagnostic_id)
VALUES
('JAVA_BACKEND', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs Java/backend diagnostic or project proof.', NULL),

('FRONTEND_APPS', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs frontend interface proof.', NULL),

('LLM_APP_ENGINEERING', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs LLM API/workflow project proof.', NULL),

('AGENTIC_WORKFLOWS', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs multi-step AI workflow proof.', NULL),

('SYSTEM_INTEGRATION', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs API/system integration proof.', NULL),

('AI_ASSISTED_DEVELOPMENT', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs evaluated AI-assisted development workflow proof.', NULL),

('EVENT_DRIVEN_SYSTEMS', 0.0, 0.0, 'low', 'not_started',
 'No accepted current evidence yet.',
 'Needs event-driven or async integration proof.', NULL);

COMMIT;
