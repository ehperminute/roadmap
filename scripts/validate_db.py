from pathlib import Path
import sqlite3
import sys

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"


def fetch_all(conn, query, params=()):
    return conn.execute(query, params).fetchall()


def fail(errors):
    print("\nVALIDATION FAILED")
    for error in errors:
        print(f"- {error}")
    raise SystemExit(1)


def column_names(conn, table_name: str) -> set[str]:
    return {
        row[1]
        for row in conn.execute(f"PRAGMA table_info({table_name});").fetchall()
    }


def main():
    errors = []
    def main():
    errors = []

    if not DB_PATH.exists():
        fail(["roadmap.db does not exist"])

    evaluation_files = sorted(
        (ROOT / "updates_sql").glob(
            "eval_[0-9][0-9][0-9][0-9].sql"
        )
    )

    if not evaluation_files:
        errors.append(
            "No evaluation SQL files found in updates_sql/"
        )

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    diagnostic_count = fetch_all(
        conn,
        "SELECT COUNT(*) FROM diagnostics;",
    )[0][0]

    if diagnostic_count != len(evaluation_files):
        errors.append(
            "Evaluation replay mismatch: "
            f"{len(evaluation_files)} SQL files but "
            f"{diagnostic_count} diagnostics in the database"
        )
    
    
    
    evaluation_files = sorted(
    (ROOT / "updates_logs").glob(
        "eval_[0-9][0-9][0-9][0-9].sql"
        )
    )
    conn = sqlite3.connect(DB_PATH)
    diagnostic_count = fetch_all(
        conn,
        "SELECT COUNT(*) FROM diagnostics;",
    )[0][0]

    if diagnostic_count != len(evaluation_files):
        errors.append(
            "Evaluation replay mismatch: "
            f"{len(evaluation_files)} SQL files but "
            f"{diagnostic_count} diagnostics in the database"
        )
    if not DB_PATH.exists():
        fail(["roadmap.db does not exist"])

    
    conn.execute("PRAGMA foreign_keys = ON")

    fk_errors = fetch_all(conn, "PRAGMA foreign_key_check;")
    if fk_errors:
        errors.append(f"Foreign-key errors found: {fk_errors}")

    current_count = fetch_all(
        conn,
        "SELECT COUNT(*) FROM current_context;",
    )[0][0]
    if current_count != 1:
        errors.append(
            f"current_context should have exactly 1 row, found {current_count}"
        )

    active_skills = fetch_all(
        conn,
        "SELECT COUNT(*) FROM skill_clusters WHERE active = 1;",
    )[0][0]
    profile_rows = fetch_all(
        conn,
        "SELECT COUNT(*) FROM profile_skill_state;",
    )[0][0]

    if active_skills != profile_rows:
        errors.append(
            "profile_skill_state should contain one row per active skill: "
            f"{profile_rows} profile rows for {active_skills} active skills"
        )

    if "next_diagnostic_id" in column_names(conn, "profile_skill_state"):
        errors.append(
            "profile_skill_state still contains obsolete next_diagnostic_id"
        )

    attempt_table = fetch_all(conn, """
        SELECT name
        FROM sqlite_master
        WHERE type = 'table'
          AND name = 'diagnostic_attempts';
    """)
    if attempt_table:
        errors.append("obsolete diagnostic_attempts table still exists")

    planned_identity_table = fetch_all(conn, """
        SELECT name
        FROM sqlite_master
        WHERE type = 'table'
          AND name = 'diagnostic_skill_clusters';
    """)
    if planned_identity_table:
        errors.append("obsolete diagnostic_skill_clusters table still exists")

    orphaned_state_events = fetch_all(conn, """
        SELECT ps.skill_cluster_id, ps.last_event_id
        FROM profile_skill_state ps
        LEFT JOIN profile_rating_events event
            ON event.id = ps.last_event_id
        WHERE event.id IS NULL
           OR event.skill_cluster_id <> ps.skill_cluster_id;
    """)
    if orphaned_state_events:
        errors.append(
            "Profile rows have missing or mismatched last events: "
            f"{orphaned_state_events}"
        )

    diagnostics_without_results = fetch_all(conn, """
        SELECT d.id
        FROM diagnostics d
        LEFT JOIN diagnostic_skill_results result
            ON result.diagnostic_id = d.id
        GROUP BY d.id
        HAVING COUNT(result.skill_cluster_id) = 0;
    """)
    if diagnostics_without_results:
        errors.append(
            "Evaluations without per-skill results: "
            f"{diagnostics_without_results}"
        )

    bad_ratings = fetch_all(conn, """
        SELECT id, skill_cluster_id, artifact_rating, reliability_rating
        FROM profile_rating_events
        WHERE artifact_rating NOT BETWEEN 0 AND 10
           OR reliability_rating NOT BETWEEN 0 AND 10;
    """)
    if bad_ratings:
        errors.append(f"Invalid profile ratings: {bad_ratings}")

    duplicate_thresholds = fetch_all(conn, """
        SELECT target_id, skill_cluster_id, COUNT(*)
        FROM target_thresholds
        GROUP BY target_id, skill_cluster_id
        HAVING COUNT(*) > 1;
    """)
    if duplicate_thresholds:
        errors.append(f"Duplicate target thresholds: {duplicate_thresholds}")

    conn.close()

    if errors:
        fail(errors)

    print("Database validation passed.")


if __name__ == "__main__":
    main()
