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
        lines.append("_No rows._")
        lines.append("")
        return lines

    columns = rows[0].keys()
    lines.append("| " + " | ".join(columns) + " |")
    lines.append("| " + " | ".join(["---"] * len(columns)) + " |")

    for row in rows:
        lines.append("| " + " | ".join(str(row[col]) if row[col] is not None else "" for col in columns) + " |")

    lines.append("")
    return lines

def main():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    lines = ["# ROADMAP_CURRENT_DIGEST", ""]

    sections = [
        ("Current Context", "SELECT * FROM current_context;"),
        ("Current Profile Ratings", "SELECT * FROM current_profile_ratings ORDER BY skill_cluster_id;"),
        ("Targets", "SELECT id, name, status FROM targets ORDER BY id;"),
        ("Target Thresholds", """
            SELECT target_id, skill_cluster_id, target_reliability, priority
            FROM target_thresholds
            ORDER BY target_id, skill_cluster_id;
        """),
        ("Diagnostics", "SELECT id, name, status, target_id FROM diagnostics ORDER BY id;"),
        ("Modules", "SELECT id, name, status, target_id FROM modules ORDER BY id;"),
        ("Tasks", "SELECT id, module_id, title, status, due_order FROM tasks ORDER BY due_order;"),
    ]

    for title, query in sections:
        lines.extend(table_to_markdown(conn, title, query))

    OUTPUT.write_text("\n".join(lines), encoding="utf-8")
    conn.close()

    print(f"Wrote {OUTPUT}")

if __name__ == "__main__":
    main()
