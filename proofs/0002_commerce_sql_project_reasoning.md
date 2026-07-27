# Evaluation 002 — Commerce SQL and Project Reasoning

## Result

**Partial pass with acknowledged assistance**

## Date

2026-07-25

## Score

**7.8 / 10 (78%)**

The score exceeds the roadmap's 75% route-defensibility threshold. Because feedback and corrections were provided during Questions 1–10, this evaluation does not constitute a fully independent pass of `sql_independence_001`.

## Evidence Basis

The evaluation used the existing commerce pipeline schema and workflow:

- PostgreSQL through Docker Compose
- `products`, `customers`, and `sales`
- synthetic customer and sales generation
- SQL analytics queries
- data-quality checks
- CSV report exports
- chart generation

## Demonstrated Abilities

The subject demonstrated:

- understanding of the project's logical execution flow;
- recognition of the grain of products, customers, and sales;
- understanding of relationships between sales, customers, and products;
- construction of ordinary multi-table joins;
- revenue calculation using quantity and product price;
- aggregation by segment, country, and month;
- filtering and ordering of report results;
- duplicate-record detection with `GROUP BY` and `HAVING`;
- detection of sales occurring before customer registration;
- appropriate caution when interpreting synthetic data;
- a practical debugging approach based on inspecting changed joins, key values, and conditions.

## Gaps Observed

The following areas were not yet reliable:

- anti-join patterns using `LEFT JOIN ... IS NULL`;
- `COUNT(*)` behavior after an unmatched left join;
- preserving customers with no sales through subsequent joins;
- exact PostgreSQL grouping and aggregate-alias rules;
- top-per-group queries;
- window functions or equivalent ranked-subquery solutions;
- exact schema-name recall and SQL string quoting.

## Key Technical Observations

The subject generally formed the correct relational structure for basic reporting queries. Minor schema-name and quoting mistakes would likely be detected during normal execution and testing.

More substantial errors appeared in:

1. customers and products with no matching sales;
2. retaining zero-revenue customers while joining products;
3. selecting the highest-revenue product separately within each category;
4. grouping all nonaggregated dimensions in an aggregate query.

## Assistance Level

`assisted_acknowledged`

## Profile Changes Supported

| Skill Cluster | Previous Reliability | Updated Reliability | Reason |
|---|---:|---:|---|
| `SQL_DATABASES` | 2.5 | 3.0 | Demonstrated basic reporting joins, aggregation, date grouping, filtering, duplicate detection, and revenue calculations. |
| `PROJECT_REASONING` | 2.5 | 3.0 | Demonstrated understanding of project flow, table relationships, data origins, and synthetic-data limitations. |
| `TESTING_DEBUGGING` | 1.5 | 2.0 | Described a reasonable incremental process for diagnosing a join that produces zero rows. |
| `DATA_QUALITY` | 2.5 | 2.5 | Demonstrated duplicate and date-consistency checks, but anti-join and null behavior remain unreliable. |

## Interpretation

The current evidence supports classification as a beginner capable of completing straightforward SQL reporting work with guidance and normal execution-based debugging.

The evidence does not yet support independent reliability in intermediate SQL involving top-per-group logic, complex aggregation, or unmatched-record handling.

## Decision

The **Data Reporting / Data Quality Trainee** bridge target remains defensible.

The next SQL work should focus on:

- anti-joins;
- null behavior;
- aggregate counting;
- customers with zero activity;
- CTEs;
- `ROW_NUMBER`, `RANK`, and `DENSE_RANK`;
- top-per-group reporting.

A complete repetition of basic `SELECT`, ordinary joins, and simple aggregation is not required.
