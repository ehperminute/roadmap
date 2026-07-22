.headers on
.mode column

SELECT
    skill_cluster_id,
    reliability_rating AS current,
    target_reliability AS target,
    reliability_gap AS gap,
    priority,
    rating_status,
    next_diagnostic_id
FROM current_profile_gap_summary
ORDER BY
    CASE priority
        WHEN 'core' THEN 1
        WHEN 'secondary' THEN 2
        WHEN 'later' THEN 3
        ELSE 4
    END,
    reliability_gap DE