"""
Write raw_artifacts.content into history/*.txt.
Process artifact_export_queue.
"""

from pathlib import Path
import sqlite3


ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"

def main():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")

    pending = conn.execute("""
        SELECT
            q.id AS queue_id,
            q.export_path,
            ra.content
        FROM artifact_export_queue q
        JOIN raw_artifacts ra ON ra.id = q.raw_artifact_id
        WHERE q.status = 'pending'
        ORDER BY q.id;
    """).fetchall()

    for row in pending:
        export_path = ROOT / row["export_path"]
        export_path.parent.mkdir(parents=True, exist_ok=True)

        try:
            export_path.write_text(row["content"], encoding="utf-8")

            conn.execute("""
                UPDATE artifact_export_queue
                SET status = 'exported',
                    exported_at = datetime('now'),
                    error_message = NULL
                WHERE id = ?;
            """, (row["queue_id"],))

            print(f"Exported {export_path}")

        except Exception as exc:
            conn.execute("""
                UPDATE artifact_export_queue
                SET status = 'failed',
                    error_message = ?
                WHERE id = ?;
            """, (str(exc), row["queue_id"]))

    conn.commit()
    conn.close()

if __name__ == "__main__":
    main()
