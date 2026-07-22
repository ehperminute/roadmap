from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"
EXPORT_DIR = ROOT / "exports"
EXPORT_DIR.mkdir(exist_ok=True)

def rows(conn, query, params=()):
    conn.row_factory = sqlite3.Row
    return conn.execute(query, params).fetchall()

def write(path: Path, content: str) -> None:
    path.write_text(content.strip() + "\n", encoding="utf-8")
    print(f"Exported {path}")

def export_skill_map(conn):
    data = rows(conn, """
        SELECT id, name, specific_skills, tools
        FROM skill_clusters
        WHERE active = 1
        ORDER BY id;
    """)

    lines = [
        "# SKILL_MAP.md",
        "",
        "## Purpose",
        "",
        "This file defines the shared skill taxonomy.",
        "",
        "## Skill Map",
        "",
        "| Skill Cluster ID | Cluster Name | Specific Skills | Tools / Technologies |",
        "|---|---|---|---|",
    ]

    for r in data:
        lines.append(
            f"| `{r['id']}` | {r['name']} | {r['specific_skills']} | {r['tools']} |"
        )

    write(EXPORT_DIR / "SKILL_MAP.md", "\n".join(lines))

def export_scale(conn):
    data = rows(conn, "SELECT score, meaning FROM scale_levels ORDER BY score;")

    lines = [
        "# SCALE.md",
        "",
        "## Rating Scale",
        "",
        "| Score | Meaning |",
        "|---:|---|",
    ]

    for r in data:
        lines.append(f"| {r['score']} | {r['meaning']} |")

    write(EXPORT_DIR / "SCALE.md", "\n".join(lines))

def export_profile(conn):
    data = rows(conn, """
        SELECT skill_cluster_id, skill_cluster_name, artifact_rating,
               reliability_rating, rating_source, notes
        FROM current_profile_ratings
        ORDER BY skill_cluster_id;
    """)

    lines = [
        "# PROFILE.md",
        "",
        "## Purpose",
        "",
        "This file summarizes the current evaluated skill profile.",
        "",
        "## Current Ratings",
        "",
        "| Skill Cluster | Artifact Rating | Reliability Rating | Source | Notes |",
        "|---|---:|---:|---|---|",
    ]

    for r in data:
        lines.append(
            f"| `{r['skill_cluster_id']}` | {r['artifact_rating']} | "
            f"{r['reliability_rating']} | {r['rating_source']} | {r['notes'] or ''} |"
        )

    write(EXPORT_DIR / "PROFILE.md", "\n".join(lines))

def export_module_current(conn):
    data = rows(conn, """
        SELECT
            cc.current_focus,
            cc.next_action,
            cc.blocker,
            t.name AS target_name,
            m.name AS module_name,
            task.title AS task_title,
            d.name AS diagnostic_name
        FROM current_context cc
        LEFT JOIN targets t ON t.id = cc.active_target_id
        LEFT JOIN modules m ON m.id = cc.active_module_id
        LEFT JOIN tasks task ON task.id = cc.active_task_id
        LEFT JOIN diagnostics d ON d.id = cc.active_diagnostic_id
        WHERE cc.id = 1;
    """)

    r = data[0]

    lines = [
        "# MODULE_CURRENT.md",
        "",
        "## Current Context",
        "",
        f"- Target: {r['target_name']}",
        f"- Module: {r['module_name']}",
        f"- Task: {r['task_title']}",
        f"- Diagnostic: {r['diagnostic_name']}",
        f"- Focus: {r['current_focus']}",
        f"- Next action: {r['next_action']}",
        f"- Blocker: {r['blocker'] or 'None'}",
    ]

    write(EXPORT_DIR / "MODULE_CURRENT.md", "\n".join(lines))

def main():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    export_scale(conn)
    export_skill_map(conn)
    export_profile(conn)
    export_module_current(conn)

    conn.close()

if __name__ == "__main__":
    main()
