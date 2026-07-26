PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO diagnostics (
    id,
    name,
    description,
    result,
    score,
    assistance_level,
    submission_text,
    evaluator_notes
)
VALUES (
    'sql_independence_002',
    'Commerce SQL and Project Reasoning Evaluation',
    'Evaluation covering reporting SQL, joins, aggregation, data quality, interpretation, project reasoning, and debugging.',
    'partial',
    7.8,
    'assisted_acknowledged',
    'See proofs/002_commerce_sql_project_reasoning.md.',
    'Questions 1-10 received immediate feedback. Basic reporting SQL was demonstrated; anti-joins, NULL behavior, exact grouping rules, and top-per-group logic remain incomplete.'
);

INSERT INTO diagnostic_skill_results
(diagnostic_id, skill_cluster_id, result, score, notes)
VALUES
('sql_independence_002', 'SQL_DATABASES', 'partial', 7.8,
 'Reliable basic joins, aggregation, date grouping, filtering, and duplicate checks; anti-joins and top-per-group logic remain weak.'),
('sql_independence_002', 'PROJECT_REASONING', 'passed', 8.0,
 'Explained project flow, table relationships, data origins, and synthetic-data limitations.'),
('sql_independence_002', 'DATA_QUALITY', 'partial', 6.5,
 'Correct duplicate and cross-table date checks; unmatched-record and NULL handling remain unreliable.'),
('sql_independence_002', 'TESTING_DEBUGGING', 'partial', 6.5,
 'Described a reasonable incremental join-debugging process, but execution evidence was not collected.');

INSERT INTO profile_rating_events
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, reason, diagnostic_id)
VALUES
('SQL_DATABASES', 3.0, 3.0, 'medium', 'updated_by_evaluation',
 'Evaluation 002 demonstrated straightforward SQL reporting with guidance; anti-joins, NULL behavior, and top-per-group logic remain incomplete.',
 'sql_independence_002'),
('PROJECT_REASONING', 3.0, 3.0, 'medium', 'updated_by_evaluation',
 'Evaluation 002 demonstrated understanding of project flow, table relationships, data origins, and synthetic-data limitations.',
 'sql_independence_002'),
('DATA_QUALITY', 3.0, 2.5, 'medium', 'updated_by_evaluation',
 'Evaluation 002 demonstrated duplicate and date-consistency checks, but anti-join and NULL handling remain unreliable; reliability unchanged.',
 'sql_independence_002'),
('TESTING_DEBUGGING', 2.0, 2.0, 'low', 'updated_by_evaluation',
 'Evaluation 002 described a reasonable incremental process for diagnosing a join that returns zero rows.',
 'sql_independence_002');

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 3.0,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 002: basic reporting joins, aggregation, date grouping, filtering, duplicate detection, and revenue calculations completed with acknowledged assistance.',
    current_limitations = 'Needs anti-joins, NULL/count behavior, CTEs, window functions, and top-per-group practice before an independent SQL pass.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_002'
          AND skill_cluster_id = 'SQL_DATABASES'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'SQL_DATABASES';

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 3.0,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 002: demonstrated project flow, table relationships, data origins, and synthetic-data limitations.',
    current_limitations = 'A future unassisted project explanation would increase confidence.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_002'
          AND skill_cluster_id = 'PROJECT_REASONING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'PROJECT_REASONING';

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 2.5,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 002: duplicate and cross-table date-consistency checks demonstrated; reliability remains unchanged.',
    current_limitations = 'Needs reliable anti-join, unmatched-record, and NULL/count handling.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_002'
          AND skill_cluster_id = 'DATA_QUALITY'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'DATA_QUALITY';

UPDATE profile_skill_state
SET
    artifact_rating = 2.0,
    reliability_rating = 2.0,
    confidence_level = 'low',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 002: described an incremental method for debugging a join that returns zero rows.',
    current_limitations = 'Debugging reasoning was verbal; independent execution and repair evidence remain pending.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_002'
          AND skill_cluster_id = 'TESTING_DEBUGGING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'TESTING_DEBUGGING';

COMMIT;
