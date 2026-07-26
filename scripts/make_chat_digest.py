from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"
OUTPUT = ROOT / "ROADMAP_CURRENT_DIGEST.txt"


def table_to_markdown(conn, title, query):
    conn.row_factory = sqlite3.Row
    rows = conn.execute(query).fetchall()

    lines = [f"## {title}", ""]

    if not rows:
        return lines + ["_No rows._", ""]

    columns = rows[0].keys()
    lines.append("| " + " | ".join(columns) + " |")
    lines.append("| " + " | ".join(["---"] * len(columns)) + " |")

    for row in rows:
        lines.append(
            "| "
            + " | ".join(
                str(row[column]) if row[column] is not None else ""
                for column in columns
            )
            + " |"
        )

    lines.append("")
    return lines


def main():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    lines = ["# ROADMAP_CURRENT_DIGEST", ""]

    sections = [
        ("Current Context", "SELECT * FROM current_context;"),
        (
            "Current Profile Ratings",
            "SELECT * FROM current_profile_ratings ORDER BY skill_cluster_id;",
        ),
        (
            "Evaluation History",
            """
            SELECT
                id,
                name,
                result,
                score,
                assistance_level,
                submission_text,
                created_at
            FROM diagnostics
            ORDER BY id;
            """,
        ),
        (
            "Evaluation Skill Results",
            """
            SELECT
                diagnostic_id,
                skill_cluster_id,
                result,
                score,
                notes
            FROM diagnostic_skill_results
            ORDER BY diagnostic_id, skill_cluster_id;
            """,
        ),
        ("Targets", "SELECT id, name, status FROM targets ORDER BY id;"),
        (
            "Target Thresholds",
            """
            SELECT target_id, skill_cluster_id, target_reliability, priority
            FROM target_thresholds
            ORDER BY target_id, skill_cluster_id;
            """,
        ),
        (
            "Modules",
            "SELECT id, name, status, target_id FROM modules ORDER BY id;",
        ),
        (
            "Tasks",
            """
            SELECT id, module_id, title, status, due_order
            FROM tasks
            ORDER BY due_order, id;
            """,
        ),
    ]

    for title, query in sections:
        lines.extend(table_to_markdown(conn, title, query))

    OUTPUT.write_text("\n".join(lines), encoding="utf-8")
    conn.close()
    print(f"Wrote {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
