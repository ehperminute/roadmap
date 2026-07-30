# Evaluation 004 — SQL Joins, Aggregation, CTEs, and NULL

## Result

- **Result:** Passed
- **Score:** 7.6 / 10
- **Assistance level:** Independent during the formal attempt
- **Evidence date:** 2026-07-29
- **Diagnostic ID:** `sql_independence_003`

The formal attempt used a fresh SQLite support-ticket schema. The subject had completed guided practice on related concepts beforehand, but no corrected query code was supplied during this evaluation.

## Skills evaluated

- `LEFT JOIN` preservation
- unmatched-parent detection
- filtering right-side matches in `ON`
- `GROUP BY` and `HAVING`
- CTE construction
- conditional aggregation
- `CASE` classification
- `COALESCE` and `NULL`
- execution-based debugging from SQLite errors

## Evidence summary

### Query 1 — All departments and ticket counts

The subject initially corrected an incorrect table name and a misspelled join column, then produced the correct counts:

```text
1|Sales|3
2|Operations|3
3|Finance|2
4|Support|2
5|Research|1
6|HR|0
```

The required explicit `ORDER BY` was omitted, although the displayed order matched the requested order.

### Query 2 — Departments with no tickets

The subject returned the correct result:

```text
6|HR
```

The requested `LEFT JOIN ... WHERE joined_id IS NULL` anti-join pattern was not used. The submitted solution used grouping and:

```sql
HAVING COUNT(st.ticket_id) = 0
```

This is logically valid for the result but did not follow the requested method.

### Query 3 — High-priority resolved tickets

The subject correctly placed both ticket filters in the `ON` clause and preserved every department:

```text
1|Sales|1|6
2|Operations|1|12
3|Finance|1|9
4|Support|0|
5|Research|0|
6|HR|0|
```

The counts were correct. `COALESCE` was omitted for the summed hours, so departments without matches displayed blank `NULL` totals instead of zero.

### Query 4 — Departments with at least two tickets

The subject correctly used `HAVING` and returned:

```text
1|Sales|3
2|Operations|3
3|Finance|2
4|Support|2
```

The explicit requested ordering was omitted, although the displayed order happened to match it.

### Query 5 — Conditional aggregation CTE

After repairing incomplete `CASE` expressions, a missing `FROM`, and an invalid alias reference inside the CTE, the subject produced correct aggregate values for departments with tickets:

```text
1|Sales|3|1|1|1|6
2|Operations|3|2|1|0|16
3|Finance|2|2|0|0|16
4|Support|2|0|1|1|0
5|Research|1|1|0|0|3
6|HR|||||
```

The CTE and conditional aggregates were correct. Missing `COALESCE` expressions left HR's metrics as `NULL`.

### Query 6 — Department classification

The submitted query executed after the subject repaired a misspelled `ELSE`. The output was:

```text
1|Sales|3|1|1|1|6|light_resolved
2|Operations|3|2|1|0|16|heavy_resolved
3|Finance|2|2|0|0|16|heavy_resolved
4|Support|2|0|1|1|0|unresolved_only
5|Research|1|1|0|0|3|light_resolved
6|HR||||||light_resolved
```

Three classifications were incorrect:

- Sales should be `active_workload`.
- Operations should be `active_workload`.
- HR should be `no_tickets`.

The causes were:

```sql
WHEN ts.open_count > 1
```

instead of the required `> 0`, and raw nullable CTE values were tested without `COALESCE`.

## Explanations

The subject correctly explained the main logical distinctions:

- A right-table condition in `ON` restricts which right-side rows attach while a `LEFT JOIN` preserves left-side rows.
- `HAVING` is used for aggregate conditions because it is evaluated after grouping, while `WHERE` filters rows before grouping.
- Missing CTE values require special handling because comparisons involving `NULL` do not evaluate as true.

## Debugging evidence

During the attempt, the subject independently repaired errors including:

- nonexistent table name;
- misspelled join column;
- nonexistent aggregate column;
- incomplete `CASE ... END` expressions;
- missing `FROM support_tickets`;
- invalid outer alias used inside a CTE;
- missing main `SELECT`;
- misspelled `ELSE`.

This supports a small Testing and Debugging increase. It does not demonstrate complete semantic verification because several queries executed successfully while still violating output requirements.

## Grading

| Area | Weight | Awarded | Notes |
|---|---:|---:|---|
| Parent preservation and counts | 10 | 9 | Correct after self-repair; explicit sort omitted. |
| No-child detection | 10 | 7 | Correct result, but requested anti-join pattern was not used. |
| Filtered `LEFT JOIN` | 15 | 13 | Correct `ON` logic; missing zero-filled sums. |
| Aggregate filtering | 10 | 9 | Correct `HAVING`; explicit sort omitted. |
| CTE and conditional aggregation | 20 | 17 | Core calculations correct; missing zero-fill for unmatched department. |
| Classification and `NULL` handling | 25 | 12 | Query executed, but three of six classifications were wrong. |
| Explanations and self-debugging | 10 | 9 | Core explanations correct and many execution errors repaired independently. |
| **Total** | **100** | **76** | **Passed** |

## Profile update

| Skill cluster | Previous artifact | New artifact | Previous reliability | New reliability |
|---|---:|---:|---:|---:|
| `SQL_DATABASES` | 3.0 | 4.0 | 3.0 | 3.5 |
| `TESTING_DEBUGGING` | 2.5 | 3.0 | 2.5 | 3.0 |

## Interpretation

The SQL increase is intentionally limited to **3.5**, halfway between:

- 3: can complete simple work with guidance;
- 4: can complete basic work with limited help.

The subject independently built and debugged several basic-to-intermediate SQL structures on a new schema, but did not consistently verify `NULL` behavior, exact requested methods, sorting, or final classification semantics.

## Remaining development targets

- Apply `COALESCE` consistently when preserving unmatched parent rows.
- Verify output against every requirement after a query executes.
- Distinguish a correct result from compliance with a specifically requested SQL pattern.
- Use explicit ordering instead of relying on current row order.
- Complete a later delayed retest to distinguish durable knowledge from immediate transfer.
- Continue with window functions and top-per-group queries after the delayed retest.
