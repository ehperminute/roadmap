.headers on
.mode column

-- Q1. Active subscriptions with invalid plans.
-- Invalid plan means:
-- missing plan OR is_active != 1 OR monthly_price <= 0
-- Output:
-- subscription_id, plan_id, issue_type

SELECT s.subscription_id, p.plan_id, 
    CASE
        WHEN p.plan_id IS NULL THEN "missing plan"
        WHEN p.is_active != 1 THEN "inactive plan"
        WHEN p.monthly_price <= 0 THEN "invalid price"
    END AS issue_type
FROM subscriptions s
    LEFT JOIN plans p ON s.plan_id = p.plan_id
WHERE 
    p.plan_id IS NULL
    OR p.is_active != 1
    OR p.monthly_price <= 0;
-- Q2. Usage events with missing subscriptions.
-- Output:
-- event_id, subscription_id, event_date, event_type
SELECT ue.event_id, ue.subscription_id, ue.event_date, ue.event_type
FROM usage_events ue
    LEFT JOIN subscriptions s ON s.subscription_id = ue.subscription_id 
        AND s.subscription_id IS NULL;    
-- Q3. Clean valid charge-event dataset.
-- Output:
-- event_id, event_date,
-- account_id, account_name, tier,
-- subscription_id,
-- plan_id, plan_name,
-- units, amount
SELECT ue.event_id, ue.event_date,
        a.account_id, a.account_name, a.tier,
        s.subscription_id,
        p.plan_id, p.plan_name,
        ue.units, ue.amount
FROM usage_events ue
    JOIN accounts a ON ue.account_id = a.account_id
    LEFT JOIN subscriptions s ON a.subscription_id = s.subscription_id AND s.subscription_id IS NOT NULL
WHERE ue.event_type = 'charge'
    AND ue.event_date >= s.start_date
    AND ue.units > 0
    AND ur.amount > 0    
-- Q4. Valid charge revenue by month and tier.
-- Month format must be YYYY-MM.
-- Output:
-- month, tier, valid_revenue

SELECT SUBSTR(ue.event_date, 1, 7) AS month, a.tier, SUM(p.monthly_price) AS valid_revenue
FROM usage_events ue 
    LEFT JOIN subscriptions s ON s.subscription_id = ue.subscription_id
        AND s.subscription_id IS NOT NULL
    JOIN plans p ON p.plan_id = s.plan_id
WHERE ue.event_type = 'charge'
    AND ue.event_date >= s.start_date
    AND p.units > 0
    AND p.amount > 0
GROUP BY month;
-- Q5. Valid charge revenue by plan.
-- Output:
-- plan_id, plan_name, valid_revenue

SELECT p.plan_id, p.plan_name, SUM(ue.amount) AS valid_revenue
FROM plans p 
    JOIN subscriptions s ON p.subscription_id = p.subscription_id
    JOIN usage_events ue ON ue.subscription_id = p.subscription_id
