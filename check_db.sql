PRAGMA foreign_keys = ON;

.tables

SELECT COUNT(*) FROM skill_clusters;
SELECT COUNT(*) FROM targets;
SELECT COUNT(*) FROM target_thresholds;
SELECT COUNT(*) FROM profile_skill_state;

SELECT
    skill_cluster_id,
    reliability_rating,
    target_reliability,
    reliability_gap,
    priority
FROM current_profile_gap_summary
LIMIT 10;
