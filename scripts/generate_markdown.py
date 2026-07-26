from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"


def rows(conn: sqlite3.Connection, query: str, params=()):
    conn.row_factory = sqlite3.Row
    return conn.execute(query, params).fetchall()


def clean(value) -> str:
    if value is None:
        return ""
    return str(value).replace("|", "\\|").replace("\n", " ")


def write(path: Path, content: str) -> None:
    path.write_text(content.strip() + "\n", encoding="utf-8")
    print(f"Exported {path.relative_to(ROOT)}")


def export_scale(conn: sqlite3.Connection) -> None:
    data = rows(conn, "SELECT score, meaning FROM scale_levels ORDER BY score;")

    lines = [
        "# SCALE.md",
        "",
        "## Rating Scale",
        "",
        "| Score | Meaning |",
        "|---:|---|",
    ]

    for row in data:
        lines.append(f"| {row['score']} | {clean(row['meaning'])} |")

    write(ROOT / "SCALE.md", "\n".join(lines))


def export_skill_map(conn: sqlite3.Connection) -> None:
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
        "This file is generated from the roadmap database.",
        "",
        "## Skill Map",
        "",
        "| Skill Cluster ID | Cluster Name | Specific Skills | Tools / Technologies |",
        "|---|---|---|---|",
    ]

    for row in data:
        lines.append(
            f"| `{row['id']}` | {clean(row['name'])} | "
            f"{clean(row['specific_skills'])} | {clean(row['tools'])} |"
        )

    write(ROOT / "SKILL_MAP.md", "\n".join(lines))


def export_profile(conn: sqlite3.Connection) -> None:
    profile = rows(conn, """
        SELECT
            skill_cluster_id,
            skill_cluster_name,
            artifact_rating,
            reliability_rating,
            confidence_level,
            rating_status,
            evidence_summary,
            current_limitations
        FROM current_profile_ratings
        ORDER BY skill_cluster_id;
    """)

    evaluations = rows(conn, """
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
    """)

    lines = [
        "# PROFILE.md",
        "",
        "## Purpose",
        "",
        "This file is generated from `roadmap.db` after the initial profile and all numbered evaluations are loaded.",
        "",
        "Do not edit ratings here; change the initial profile or add an evaluation SQL file, rebuild the database, and regenerate this document.",
        "",
        "## Current Ratings",
        "",
        "| Skill Cluster | Artifact | Reliability | Confidence | Status | Evidence | Current limitations |",
        "|---|---:|---:|---|---|---|---|",
    ]

    for row in profile:
        lines.append(
            f"| `{row['skill_cluster_id']}` | "
            f"{row['artifact_rating']} | "
            f"{row['reliability_rating']} | "
            f"{clean(row['confidence_level'])} | "
            f"{clean(row['rating_status'])} | "
            f"{clean(row['evidence_summary'])} | "
            f"{clean(row['current_limitations'])} |"
        )

    lines.extend([
        "",
        "## Evaluation History",
        "",
        "| Evaluation ID | Name | Result | Score | Assistance | Evidence |",
        "|---|---|---|---:|---|---|",
    ])

    for row in evaluations:
        score = "" if row["score"] is None else row["score"]
        lines.append(
            f"| `{row['id']}` | {clean(row['name'])} | "
            f"{clean(row['result'])} | {score} | "
            f"{clean(row['assistance_level'])} | "
            f"{clean(row['submission_text'])} |"
        )

    write(ROOT / "PROFILE.md", "\n".join(lines))


def export_module_current(conn: sqlite3.Connection) -> None:
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
        LEFT JOIN targets t
            ON t.id = cc.active_target_id
        LEFT JOIN modules m
            ON m.id = cc.active_module_id
        LEFT JOIN tasks task
            ON task.id = cc.active_task_id
        LEFT JOIN diagnostics d
            ON d.id = cc.active_diagnostic_id
        WHERE cc.id = 1;
    """)

    row = data[0]

    lines = [
        "# MODULE_CURRENT.md",
        "",
        "## Current Context",
        "",
        f"- Target: {clean(row['target_name']) or 'None'}",
        f"- Module: {clean(row['module_name']) or 'None'}",
        f"- Task: {clean(row['task_title']) or 'None'}",
        f"- Diagnostic: {clean(row['diagnostic_name']) or 'None'}",
        f"- Focus: {clean(row['current_focus']) or 'None'}",
        f"- Next action: {clean(row['next_action']) or 'None'}",
        f"- Blocker: {clean(row['blocker']) or 'None'}",
    ]

    write(ROOT / "MODULE_CURRENT.md", "\n".join(lines))


def main() -> None:
    if not DB_PATH.exists():
        raise FileNotFoundError(
            "roadmap.db does not exist. Run python scripts/init_db.py first."
        )

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    try:
        export_scale(conn)
        export_skill_map(conn)
        export_profile(conn)
        export_module_current(conn)
    finally:
        conn.close()


if __name__ == "__main__":
    main()
