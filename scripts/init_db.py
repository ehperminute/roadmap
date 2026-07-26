from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"
TEMP_DB_PATH = ROOT / "roadmap.db.tmp"
UPDATES_DIR = ROOT / "updates_logs"

BASE_SQL_FILES = [
    ROOT / "sql" / "schema.sql",
    ROOT / "sql" / "insert_targets.sql",
    ROOT / "sql" / "current_profile.sql",
]


def run_sql_file(conn: sqlite3.Connection, path: Path) -> None:
    if not path.exists():
        raise FileNotFoundError(f"Missing SQL file: {path}")

    print(f"Applying {path.relative_to(ROOT)}")
    conn.executescript(path.read_text(encoding="utf-8"))


def main() -> None:
    # Build a complete replacement first. The existing database remains usable
    # if any source file fails.
    TEMP_DB_PATH.unlink(missing_ok=True)
    conn = sqlite3.connect(TEMP_DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    try:
        for sql_file in BASE_SQL_FILES:
            run_sql_file(conn, sql_file)

        for evaluation_file in sorted(UPDATES_DIR.glob("*.sql")):
            run_sql_file(conn, evaluation_file)

        fk_errors = conn.execute("PRAGMA foreign_key_check").fetchall()
        if fk_errors:
            raise RuntimeError(f"Foreign-key validation failed: {fk_errors}")

        conn.commit()
    except Exception:
        conn.close()
        TEMP_DB_PATH.unlink(missing_ok=True)
        raise
    else:
        conn.close()
        TEMP_DB_PATH.replace(DB_PATH)
        print(f"Database rebuilt: {DB_PATH}")


if __name__ == "__main__":
    main()
