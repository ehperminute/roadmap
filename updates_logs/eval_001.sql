PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

CREATE TEMP TABLE _eval_attempt_id (id INTEGER);

INSERT INTO diagnostic_attempts
(diagnostic_id, attempt_summary, submission_text, result, score, evaluator_notes)
VALUES (
    'sql_independence_001',
    'SQL/Data Quality repair gate completed after acknowledged assistance.',
    'See proofs/001_sql_data_quality_modeling/evaluator_result.md.',
    'partial',
    5.0,
    'Small profile update only. Full independent diagnostic remains pending.'
);

INSERT INTO _eval_attempt_id
SELECT last_insert_rowid();

INSERT INTO profile_rating_events
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, reason, diagnostic_attempt_id)
VALUES
('SQL_DATABASES', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Corrected JOIN, LEFT JOIN, aliasing, and filtering patterns after feedback.',
 (SELECT id FROM _eval_attempt_id)),

('DATA_QUALITY', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Corrected missing-reference checks and invalid-value filtering after feedback.',
 (SELECT id FROM _eval_attempt_id)),

('DATA_MODELING', 2.5, 2.0, 'medium', 'updated_by_evaluation',
 'Improved table relationship logic among customers, orders, order_items, and products.',
 (SELECT id FROM _eval_attempt_id)),

('TESTING_DEBUGGING', 2.0, 1.5, 'low', 'updated_by_evaluation',
 'Repaired syntax, alias, join, and condition errors through attempts.',
 (SELECT id FROM _eval_attempt_id)),

('PROJECT_REASONING', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Improved reasoning about valid rows, missing references, and revenue eligibility.',
 (SELECT id FROM _eval_attempt_id));

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 2.5,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 001 repair gate: corrected JOIN, LEFT JOIN, missing-reference, and filtering patterns after acknowledged assistance.',
    current_limitations = 'Full independent SQL/data-quality diagnostic still pending.',
    last_event_id = (
        SELECT MAX(id) FROM profile_rating_events
        WHERE skill_cluster_id = profile_skill_state.skill_cluster_id
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
        SELECT MAX(id) FROM profile_rating_events
        WHERE skill_cluster_id = profile_skill_state.skill_cluster_id
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
        SELECT MAX(id) FROM profile_rating_events
        WHERE skill_cluster_id = profile_skill_state.skill_cluster_id
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
        SELECT MAX(id) FROM profile_rating_events
        WHERE skill_cluster_id = profile_skill_state.skill_cluster_id
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'PROJECT_REASONING';

DROP TABLE _eval_attempt_id;

COMMIT;
