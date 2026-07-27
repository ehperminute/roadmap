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
    'pandas_data_quality_003',
    'Pandas Data Quality Evaluation 003',
    'Executed pandas evaluation covering deduplication, normalization, typed conversion, validation flags, accepted/rejected row separation, conditional revenue, grouped reports, assertions, and CSV export.',
    'passed',
    8.8,
    'independent',
    'See proofs/0003_pandas_data_quality.md.',
    'The final retake ran successfully and produced correct row splits, validation outcomes, revenue totals, and grouped summaries. Minor deductions were for export/report formatting, aggregate reason-count reporting, defensive conversion details, and duplicated code.'
);

INSERT INTO diagnostic_skill_results
(diagnostic_id, skill_cluster_id, result, score, notes)
VALUES
('pandas_data_quality_003', 'PYTHON_DATA_WORK', 'passed', 8.8,
 'Built and executed a complete pandas cleaning and reporting pipeline with explicit date parsing, vectorized text and numeric conversion, boolean validation, conditional assignment, grouping, assertions, and exports.'),
('pandas_data_quality_003', 'DATA_QUALITY', 'passed', 9.0,
 'Correctly preserved and removed exact duplicates, created six rule-level validation flags, separated valid and rejected records, attached failure flags, and reconciled accepted/rejected totals.'),
('pandas_data_quality_003', 'REPORTING', 'passed', 8.2,
 'Produced correct branch and monthly completed-sales summaries and identified the highest-revenue branch and month; grouping keys remained indexes and CSV exports retained indexes.'),
('pandas_data_quality_003', 'TESTING_DEBUGGING', 'passed', 8.5,
 'Executed the pipeline, corrected environment-specific date parsing, added reconciliation and revenue assertions, and supplied actual successful output rather than an unexecuted draft.');

INSERT INTO profile_rating_events
(skill_cluster_id, artifact_rating, reliability_rating, confidence_level, rating_status, reason, diagnostic_id)
VALUES
('PYTHON_DATA_WORK', 3.5, 3.0, 'medium', 'updated_by_evaluation',
 'Independent Evaluation 003 demonstrated a working end-to-end pandas cleaning, validation, reporting, assertion, and export pipeline.',
 'pandas_data_quality_003'),
('DATA_QUALITY', 3.0, 3.0, 'medium', 'updated_by_evaluation',
 'Independent Evaluation 003 demonstrated rule-level validation flags, duplicate handling, rejected-row evidence, and row-count reconciliation.',
 'pandas_data_quality_003'),
('REPORTING', 3.0, 3.0, 'medium', 'updated_by_evaluation',
 'Independent Evaluation 003 produced correct branch and monthly revenue summaries from completed valid records.',
 'pandas_data_quality_003'),
('TESTING_DEBUGGING', 2.5, 2.5, 'medium', 'updated_by_evaluation',
 'Independent Evaluation 003 included executed checks for row reconciliation, validation cleanliness, nonnegative revenue, and report-total equality.',
 'pandas_data_quality_003');

UPDATE profile_skill_state
SET
    artifact_rating = 3.5,
    reliability_rating = 3.0,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 003: independently executed pandas pipeline for deduplication, normalization, conversion, validation, conditional revenue, grouping, assertions, and CSV output.',
    current_limitations = 'Needs cleaner production structure, defensive conversion on every input, reduced duplication, and more practice with report-ready indexes and output formatting.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'pandas_data_quality_003'
          AND skill_cluster_id = 'PYTHON_DATA_WORK'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'PYTHON_DATA_WORK';

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 3.0,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 003: independently created rule-level validation checks, preserved duplicate evidence, separated accepted and rejected rows, and reconciled record counts.',
    current_limitations = 'Needs broader multi-rule examples, source-contract documentation, and production handling of nullable text fields and unexpected schemas.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'pandas_data_quality_003'
          AND skill_cluster_id = 'DATA_QUALITY'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'DATA_QUALITY';

UPDATE profile_skill_state
SET
    artifact_rating = 3.0,
    reliability_rating = 3.0,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 003: independently produced correct branch and monthly completed-revenue summaries and identified leading periods and branches.',
    current_limitations = 'Needs report-ready column layout, index-free exports, clearer findings output, visualization, and spreadsheet or BI reporting evidence.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'pandas_data_quality_003'
          AND skill_cluster_id = 'REPORTING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'REPORTING';

UPDATE profile_skill_state
SET
    artifact_rating = 2.5,
    reliability_rating = 2.5,
    confidence_level = 'medium',
    rating_status = 'updated_by_evaluation',
    evidence_summary = 'Evaluation 003: executed and debugged the pipeline, handled a pandas-version date-parsing issue, and verified reconciliation and revenue invariants.',
    current_limitations = 'Needs isolated functions, automated tests for exact outputs and edge cases, cleaner failure messages, and regression-style reruns.',
    last_event_id = (
        SELECT id
        FROM profile_rating_events
        WHERE diagnostic_id = 'pandas_data_quality_003'
          AND skill_cluster_id = 'TESTING_DEBUGGING'
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE skill_cluster_id = 'TESTING_DEBUGGING';

COMMIT;
