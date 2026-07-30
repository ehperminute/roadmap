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
    'sql_independence_003',
    'SQL Joins, Aggregation, and CTE Evaluation 004',
    'Fresh SQLite evaluation covering LEFT JOIN preservation, anti-join logic, aggregate filtering, conditional aggregation, CTEs, CASE classification, NULL handling, and execution-based debugging.',
    'passed',
    7.6,
    'independent',
    'See proofs/0004_sql_joins_aggregation_ctes.md.',
    'The subject completed the evaluation without corrected query code during the attempt and repaired multiple parser, schema-name, alias, missing-FROM, grouping, and CASE syntax errors from SQLite feedback. Correct relational and aggregate logic was demonstrated, but the final submission missed required COALESCE handling in several outputs, used GROUP BY/HAVING instead of the requested anti-join pattern, omitted explicit sorting in some queries, and misclassified three departments because of NULL handling and an open_count > 1 condition.'
);

INSERT INTO diagnostic_skill_results
(diagnostic_id, skill_cluster_id, result, score, notes)
VALUES
('sql_independence_003', 'SQL_DATABASES', 'passed', 7.6,
 'Independently constructed and executed LEFT JOIN counts, aggregate filtering with HAVING, filtered joins in ON, a CTE, conditional aggregation, and CASE classification. Remaining errors involved exact requirement adherence, repeated COALESCE handling after LEFT JOIN, and one incorrect comparison threshold.'),
('sql_independence_003', 'TESTING_DEBUGGING', 'passed', 7.5,
 'Used SQLite error messages to repair table and column names, aliases, missing FROM clauses, incomplete CASE expressions, and grouping references without receiving corrected query code. Semantic output validation remained incomplete because NULL-related and classification errors were not corrected before submission.');

INSERT INTO profile_rating_events
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, reason, diagnostic_id)
VALUES
('SQL_DATABASES', 4.0, 3.5, 'medium', 'updated_by_evaluation',
 'Evaluation 004 demonstrated an independent fresh-schema attempt using LEFT JOIN, HAVING, CTEs, conditional aggregation, CASE, and iterative execution-based repair; reliability remains below 4 because several semantic and specification errors remained in the submitted outputs.',
 'sql_independence_003'),
('TESTING_DEBUGGING', 3.0, 3.0, 'medium', 'updated_by_evaluation',
 'Evaluation 004 provided direct evidence of independently reading and repairing SQLite parser and schema errors across multiple attempts; semantic verification of final outputs remains inconsistent.',
 'sql_independence_003');

UPDATE profile_skill_state
SET
    artifact_rating = 4.0,
    reliability_rating = 3.5,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 004: independently constructed and executed LEFT JOIN, HAVING, CTE, conditional-aggregation, and CASE queries on a fresh support-ticket schema while repairing multiple SQLite errors from execution feedback.',
    current_limitations = 'Needs consistent COALESCE handling after LEFT JOIN, exact adherence to requested anti-join and sorting requirements, semantic verification of final outputs, and later practice with window functions and top-per-group queries.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_003'
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
    evidence_summary = 'Evaluation 004: independently used SQLite error output to repair table names, column names, aliases, missing clauses, grouping references, and CASE syntax across repeated executions.',
    current_limitations = 'Needs stronger semantic debugging: compare final output against every requirement, deliberately test NULL cases, and add explicit verification queries or assertions instead of stopping when SQL executes.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'sql_independence_003'
          AND skill_cluster_id = 'TESTING_DEBUGGING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'TESTING_DEBUGGING';

COMMIT;
