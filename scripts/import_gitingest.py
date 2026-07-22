"""
Purpose:

Import a raw Gitingest text file into raw_artifacts.
Optionally link it to a project.

Example use:

python scripts/import_gitingest.py \
  --file history/commerce-pipeline-2026-07-13.txt \
  --artifact-id commerce_pipeline_digest_2026_07_13 \
  --project-id commerce_pipeline \
  --source-name commerce-pipeline-2026-07-13.txt
"""

from pathlib import Path
import argparse
import hashlib
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "roadmap.db"

def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True)
    parser.add_argument("--artifact-id", required=True)
    parser.add_argument("--source-name", required=True)
    parser.add_argument("--project-id")
    args = parser.parse_args()

    path = ROOT / args.file
    content = path.read_text(encoding="utf-8")
    content_hash = sha256_text(content)

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")

    conn.execute("""
        INSERT INTO raw_artifacts
        (id, artifact_type, source_name, source_path, content, content_hash, notes)
        VALUES (?, 'repo_digest', ?, ?, ?, ?, NULL)
        ON CONFLICT(id) DO UPDATE SET
            source_name = excluded.source_name,
            source_path = excluded.source_path,
            content = excluded.content,
            content_hash = excluded.content_hash;
    """, (
        args.artifact_id,
        args.source_name,
        args.file,
        content,
        content_hash,
    ))

    if args.project_id:
        conn.execute("""
            INSERT OR IGNORE INTO project_artifacts
            (project_id, raw_artifact_id, relationship)
            VALUES (?, ?, 'repo_digest');
        """, (args.project_id, args.artifact_id))

    conn.commit()
    conn.close()

    print(f"Imported {path} as {args.artifact_id}")

if __name__ == "__main__":
    main()
