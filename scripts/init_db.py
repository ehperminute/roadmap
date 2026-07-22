from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"

SQL_FILES = [
    ROOT / "schema.sql",
    ROOT / "insert_targets.sql",
]

def run_sql_file(conn: sqlite3.Connection, path: Path) -> None:
    if not path.exists():
        raise FileNotFoundError(f"Missing SQL file: {path}")

    sql = path.read_text(encoding="utf-8")
    conn.executescript(sql)

def main() -> None:
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    try:
        for sql_file in SQL_FILES:
            print(f"Applying {sql_file.name}")
            run_sql_file(conn, sql_file)

        conn.commit()
        print(f"Database initialized: {DB_PATH}")

    except Exception:
        conn.rollback()
        raise

    finally:
        conn.close()

if __name__ == "__main__":
    main()
