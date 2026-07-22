from pathlib import Path
import sqlite3
import sys

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"

def fetch_all(conn, query, params=()):
    return conn.execute(query, params).fetchall()

def fail(errors):
    print("\nVALIDATION FAILED")
    for err in errors:
        print(f"- {err}")
    sys.exit(1)

def main():
    errors = []

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    fk_errors = fetch_all(conn, "PRAGMA foreign_key_check;")
    if fk_errors:
        errors.append(f"Foreign key errors found: {fk_errors}")

    current_count = fetch_all(conn, "SELECT COUNT(*) FROM current_context;")[0][0]
    if current_count != 1:
        errors.append(f"current_context should have exactly 1 row, found {current_count}")

    bad_skill_ids = fetch_all(conn, """
        SELECT DISTINCT skill_cluster_id
        FROM target_thresholds
        WHERE skill_cluster_id NOT IN (SELECT id FROM skill_clusters);
    """)
    if bad_skill_ids:
        errors.append(f"target_thresholds has unknown skill IDs: {bad_skill_ids}")

    legacy_ids = fetch_all(conn, """
        SELECT id FROM skill_clusters
        WHERE id IN ('APIS', 'ML_BASICS');
    """)
    if legacy_ids:
        errors.append(f"Legacy skill IDs still exist: {legacy_ids}")

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
