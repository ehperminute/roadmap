# Evaluation 003 — pandas Data Quality Pipeline

## Result

- **Result:** Passed
- **Score:** 9.3 / 10
- **Assistance level:** Independent
- **Evaluation type:** Executed retake
- **Evidence date:** 2026-07-27

The earlier unexecuted draft was voided. This result is based only on the fresh retake, which was executed, debugged, and submitted with actual output.

## Evidence organization

This Markdown file is the complete proof artifact. It contains:

1. the evaluation task;
2. the final submitted code;
3. execution evidence;
4. the grading decision;
5. the supported profile update.

The SQL file records the result in the database. It does not need to contain the full task or source code.

---

## Evaluation task

### Dataset contract

- Dates use `DD/MM/YYYY`.
- Invalid values must not be repaired or invented.
- Exact duplicates must be preserved for evidence and removed from the working data.
- Documentation, execution, and self-debugging are allowed.

### Required pipeline

1. Load the CSV and preserve removed exact duplicates.
2. Normalize branch, channel, and status text.
3. Convert dates, units, prices, and discounts.
4. Create these boolean validation columns:
   - `invalid_date`
   - `invalid_units`
   - `invalid_price`
   - `invalid_discount`
   - `invalid_branch`
   - `invalid_status`
5. Split valid and rejected records.
6. Attach validation flags to rejected records.
7. Count failures by validation rule.
8. Calculate completed-only net revenue.
9. Produce branch and monthly completed-sales reports.
10. Verify row reconciliation and revenue totals.
11. Export four CSV files without indexes.
12. Print record counts, validation counts, reports, and leading branch/month.

---

## Final submitted code

```python
import pandas as pd
import io

csv_data = """sale_id,sale_date,branch,channel,units,unit_price,discount,status
S001,01/05/2026," north ",Online,2,"$150.00",10%,Complete
S002,02/05/2026,NORTH,store,1,200,0.05,completed
S003,03/05/2026,South,Online,3,100,0%,Refund
S004,31/04/2026,South,Store,2,90,0%,completed
S005,05/05/2026,Central,online,0,80,0%,completed
S006,06/06/2026,central,Store,4,"1,200.00",15%,completed
S007,07/06/2026,East,Online,2,50,0%,completed
S008,08/06/2026,North,Online,2,free,0%,completed
S009,09/06/2026,South,Store,2,120,60%,completed
S010,10/06/2026,South,store,2,120,0.10,Cancelled
S002,02/05/2026,NORTH,store,1,200,0.05,completed"""

df = pd.read_csv(io.StringIO(csv_data))

row_count = len(df)
duplicates_df = df[df.duplicated()].copy()
rows_dup = len(duplicates_df)
rows_unique = row_count - rows_dup
df1 = df.drop_duplicates()
df1

df1["branch"] = df1["branch"].str.strip().str.title()
df1["channel"] = df1["channel"].str.strip().str.title()
df1["status"] = df1["status"].str.strip().str.lower()
df1.loc[df1["status"] == "complete", "status"] = "completed"
df1.loc[df1["status"] == "refund", "status"] = "refunded"
df1["sale_date"] = pd.to_datetime(df1["sale_date"], format="%d/%m/%Y", errors="coerce")
df1["units"] = pd.to_numeric(df1["units"])
df1["unit_price"] = df1["unit_price"].str.replace(r"\$|,", "", regex=True)
df1["unit_price"] = pd.to_numeric(df1["unit_price"], errors="coerce")
df1.loc[df1["discount"].str.endswith("%"), "discount"] = df1.loc[df1["discount"].str.endswith("%"), "discount"].str.replace("%", "").astype("float64").div(100).round(decimals=2).astype(str)
df1["discount"] = pd.to_numeric(df1["discount"])

checks = pd.DataFrame()
checks["invalid_date"] = df1["sale_date"].isna()
checks["invalid_units"] = df1["units"].isna() | (df1["units"] <= 0) | (df1["units"]) % 1 != 0
checks["invalid_price"] = (df1["unit_price"] <= 0) | df1["unit_price"].isna()
checks["invalid_discount"] = (df1["discount"] < 0) | (df1["discount"] > 0.5) | df1["discount"].isna()
checks["invalid_branch"] = df1["branch"].isna() | ~df1["branch"].isin(("North", "South", "Central"))
checks["invalid_status"] = df1["status"].isna() | ~df1["status"].isin(("completed", "refunded", "cancelled"))
rejected_mask = checks.any(axis=1)
valid_df = df1[~rejected_mask]
rejected_df = df1[rejected_mask]

rejected_df = pd.concat([rejected_df, checks[rejected_mask]], axis=1)
rejected_df["reason_counts"] = checks.sum(axis=1)[rejected_df.index]
valid_df["net_revenue"] = 0
valid_df.loc[valid_df["status"] == "completed", "net_revenue"] = (valid_df.loc[valid_df["status"] == "completed"]["units"] * valid_df.loc[valid_df["status"] == "completed"]["unit_price"] * (1 - valid_df.loc[valid_df["status"] == "completed"]["discount"])).round(decimals=2)
valid_df["net_revenue"] = 0
valid_df.loc[valid_df["status"] == "completed", "net_revenue"] = (valid_df.loc[valid_df["status"] == "completed"]["units"] * valid_df.loc[valid_df["status"] == "completed"]["unit_price"] * (1 - valid_df.loc[valid_df["status"] == "completed"]["discount"])).round(decimals=2)
branch_summary = valid_df[valid_df["status"] == "completed"].groupby("branch").agg(completed_records = ("sale_id", "size"),
                               units_sold = ("units", "sum"),
                               net_revenue = ("net_revenue", "sum")).sort_values(by="net_revenue", ascending=False).copy()
monthly_summary = valid_df[valid_df["status"] == "completed"].groupby(pd.Grouper(key='sale_date',
                      freq='MS')).agg(completed_records = ("sale_id", "size"),
                               units_sold = ("units", "sum"),
                               net_revenue = ("net_revenue", "sum")).sort_values(by="sale_date").copy()
for check in (len(valid_df) + len(rejected_df) + len(duplicates_df) == len(df),
not checks.loc[valid_df.index].any(axis=None),
(valid_df["net_revenue"] >= 0).all()):
    print(check)
print(valid_df["net_revenue"].sum() == branch_summary["net_revenue"].sum() == monthly_summary["net_revenue"].sum())
for report, filename in ((valid_df, "clean_sales_eval3.csv"),
(rejected_df, "rejected_sales_eval3.csv"),
(branch_summary, "branch_summary_eval3.csv"),
(monthly_summary, "monthly_summary_eval3.csv")):
    report.to_csv(filename)

print("Original rows:\n", df)
print("Duplicates:\n", duplicates_df)
print("Valid rows:\n", valid_df)
print("Rejected rows:\n", rejected_df)
print("Rejection reasons count:\n", rejected_df[["sale_id", "reason_counts"]])
print("Branch summary:\n", branch_summary)
print("Monthly summary:\n", monthly_summary)
print("Highest revenue branch:\n", branch_summary.head(1))
print("Highest revenue month:\n", monthly_summary.sort_values(by="net_revenue", ascending=False).head(1))

```

---

## Execution evidence

All submitted verification expressions evaluated to `True`:

```text
True
True
True
True
```

### Record reconciliation

| Metric | Result |
|---|---:|
| Original records | 11 |
| Exact duplicates removed | 1 |
| Records after deduplication | 10 |
| Valid records | 5 |
| Rejected records | 5 |

### Validation failures by rule

The submitted `checks` DataFrame supports the following aggregate counts:

| Validation rule | Failed records |
|---|---:|
| `invalid_date` | 1 |
| `invalid_units` | 1 |
| `invalid_price` | 1 |
| `invalid_discount` | 1 |
| `invalid_branch` | 1 |
| `invalid_status` | 0 |

The submitted column named `reason_counts` had a different meaning: it counted the number of failed validation rules **within each rejected sale**. Every rejected sale in this dataset failed exactly one rule.

### Valid records and revenue

| Sale | Status | Net revenue |
|---|---|---:|
| S001 | completed | 270.00 |
| S002 | completed | 190.00 |
| S003 | refunded | 0.00 |
| S006 | completed | 4080.00 |
| S010 | cancelled | 0.00 |
| **Total** |  | **4540.00** |

### Branch report

| Branch | Completed records | Units sold | Net revenue |
|---|---:|---:|---:|
| Central | 1 | 4 | 4080.00 |
| North | 2 | 3 | 460.00 |

### Monthly report

The submitted timestamp index represents the first day of each monthly bucket.

| Month bucket | Completed records | Units sold | Net revenue |
|---|---:|---:|---:|
| 2026-05-01 | 2 | 3 | 460.00 |
| 2026-06-01 | 1 | 4 | 4080.00 |

Highest-revenue branch: **Central**

Highest-revenue month: **June 2026**

---

## Grading

| Section | Points | Awarded | Notes |
|---|---:|---:|---|
| Load and deduplicate | 10 | 10 | Correct duplicate preservation, removal, and reconciliation. Using `df1` is appropriate under Marimo's single-assignment execution model. |
| Normalize text | 10 | 10 | Required branch, channel, and status values were normalized correctly. |
| Convert data types | 20 | 19 | Correct explicit date contract and working price/discount conversion. `units` did not use `errors="coerce"`. |
| Validation flags | 20 | 18 | All six rule flags and the valid/rejected split were correct. The submission produced per-record failed-rule counts rather than the requested aggregate counts by rule. |
| Revenue | 10 | 10 | Correct completed-only calculation, zero for refunded/cancelled records, rounding, and reconciliation. The repeated block was redundant but did not change correctness. |
| Reports | 15 | 13 | Numeric results and sorting were correct. Group keys remained indexes and the month was represented as a monthly timestamp rather than the requested `YYYY-MM` display value. |
| Verification | 10 | 10 | All row, validation, nonnegative-revenue, and report-total checks passed. |
| Export and findings | 5 | 3 | All files and detailed tables were produced. `index=False` was omitted and concise scalar counts were not printed separately. |
| **Total** | **100** | **93** | **Passed** |

---

## Clarifications

### Per-record failed-rule count

```python
checks.sum(axis=1)
```

This sums horizontally across validation columns. It answers:

> How many validation rules did this one sale fail?

A clearer name is:

```python
rejected_df["failed_rule_count"] = (
    checks.loc[rejected_mask].sum(axis=1)
)
```

### Aggregate reason count

```python
checks.sum()
```

This sums vertically down the records. It answers:

> How many sales failed each validation rule?

```python
reason_counts = (
    checks.loc[rejected_mask]
    .sum()
    .sort_values(ascending=False)
)
```

Both outputs are useful; they answer different questions.

### Monthly timestamp versus `YYYY-MM`

The monthly timestamp is not technically worse. It is useful for time-series operations and chronological sorting. It simply did not match the requested report display.

Two valid display choices are:

```python
month = completed_df["sale_date"].dt.to_period("M")
```

or:

```python
month = completed_df["sale_date"].dt.strftime("%Y-%m")
```

The correct format is `%Y-%m`. `%M` means minutes.

### Scalar findings

A scalar count is one number rather than a complete table:

```python
print("Original rows:", row_count)
print("Duplicates removed:", rows_dup)
print("Valid rows:", len(valid_df))
print("Rejected rows:", len(rejected_df))
```

Printing the full DataFrames is still useful evidence. The requested findings section was meant to add these concise totals, not replace the detailed tables.

---

## Profile update

| Skill cluster | Previous reliability | New reliability |
|---|---:|---:|
| `PYTHON_DATA_WORK` | 2.5 | 3.0 |
| `DATA_QUALITY` | 2.5 | 3.0 |
| `REPORTING` | 2.5 | 3.0 |
| `TESTING_DEBUGGING` | 2.0 | 2.5 |

## Remaining development targets

- Consistently use tolerant conversion for external inputs.
- Distinguish per-record validation counts from aggregate counts by rule.
- Produce report-ready columns instead of index-only grouping labels.
- Export with `index=False`.
- Add concise findings alongside detailed evidence.
- Remove redundant code before committing.
