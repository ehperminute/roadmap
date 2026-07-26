PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- Evaluation 001 completes the pre-seeded sql_independence_001 record.
UPDATE diagnostics
SET
    name = 'SQL Independence Evaluation 001',
    description = 'SQL and data-quality repair gate completed after acknowledged assistance.',
    status = 'active',
    result = 'partial',
    score = 5.0,
    assistance_level = 'assisted_acknowledged',
    submission_text = 'See proofs/001_sql_data_quality_modeling.md.',
    evaluator_notes = 'Small profile update only. Full independent diagnostic remains pending.',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 'sql_independence_001';

INSERT INTO diagnostic_skill_clusters (diagnostic_id, skill_cluster_id)
VALUES
('sql_independence_001', 'SQL_DATABASES'),
('sql_independence_001', 'DATA_QUALITY'),
('sql_independence_001', 'DATA_MODELING'),
('sql_independence_001', 'TESTING_DEBUGGING'),
('sql_independence_001', 'PROJECT_REASONING');

INSERT INTO diagnostic_skill_results
(diagnostic_id, skill_cluster_id, result, score, notes)
VALUES
('sql_independence_001', 'SQL_DATABASES', 'partial', 5.0,
 'Corrected JOIN, LEFT JOIN, aliasing, and filtering patterns after feedback.'),
('sql_independence_001', 'DATA_QUALITY', 'partial', 5.0,
 'Corrected missing-reference checks and invalid-value filtering after feedback.'),
('sql_independence_001', 'DATA_MODELING', 'partial', 5.0,
 'Improved table relationship logic among customers, orders, order_items, and products.'),
('sql_independence_001', 'TESTING_DEBUGGING', 'partial', 5.0,
 'Repaired syntax, alias, join, and condition errors through attempts.'),
('sql_independence_001', 'PROJECT_REASONING', 'partial', 5.0,
 'Improved reasoning about valid rows, missing references, and revenue eligibility.');

INSERT INTO profile_rating_events
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, reason, diagnostic_id)
VALUES
('SQL_DATABASES', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Corrected JOIN, LEFT JOIN, aliasing, and filtering patterns after feedback.',
 'sql_independence_001'),
('DATA_QUALITY', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Corrected missing-reference checks and invalid-value filtering after feedback.',
 'sql_independence_001'),
('DATA_MODELING', 2.5, 2.0, 'medium', 'updated_by_evaluation',
 'Improved table relationship logic among customers, orders, order_items, and products.',
 'sql_independence_001'),
('TESTING_DEBUGGING', 2.0, 1.5, 'low', 'updated_by_evaluation',
 'Repaired syntax, alias, join, and condition errors through attempts.',
 'sql_independence_001'),
('PROJECT_REASONING', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Improved reasoning about valid rows, missing references, and revenue eligibility.',
 'sql_independence_001');

-- Evaluation 002 is defined here so profile rows may reference it as next.
INSERT INTO diagnostics (id, name, description, status)
VALUES (
    'sql_independence_002',
    'SQL Independence Evaluation 002',
    'Commerce SQL and project-reasoning evaluation.',
    'planned'
);

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 2.5,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 001 repair gate: corrected JOIN, LEFT JOIN, missing-reference, and filtering patterns after acknowledged assistance.',
    current_limitations = 'Full independent SQL/data-quality diagnostic still pending.',
    next_diagnostic_id = 'sql_independence_002',
    last_event_id = (
        SELECT id FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_001'
          AND skill_cluster_id = profile_skill_state.skill_cluster_id
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id IN ('SQL_DATABASES', 'DATA_QUALITY');

UPDATE profile_skill_state
SET
    artifact_rating = 2.5,
    reliability_rating = 2.0,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 001 repair gate: improved table relationship logic.',
    current_limitations = 'Needs stronger independent schema, grain, and relationship checks.',
    last_event_id = (
        SELECT id FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_001'
          AND skill_cluster_id = 'DATA_MODELING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'DATA_MODELING';

UPDATE profile_skill_state
SET
    artifact_rating = 2.0,
    reliability_rating = 1.5,
    confidence_level = 'low',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 001 repair gate: corrected syntax, alias, join, and condition errors through attempts.',
    current_limitations = 'Debugging remains assisted; independent error-repair proof still needed.',
    last_event_id = (
        SELECT id FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_001'
          AND skill_cluster_id = 'TESTING_DEBUGGING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'TESTING_DEBUGGING';

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 2.5,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 001 repair gate: improved valid-row and revenue-eligibility reasoning.',
    current_limitations = 'Full project explanation and independent diagnostic still pending.',
    last_event_id = (
        SELECT id FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_001'
          AND skill_cluster_id = 'PROJECT_REASONING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'PROJECT_REASONING';

COMMIT;
