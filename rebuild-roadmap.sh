#!/usr/bin/env bash
set -euo pipefail

python scripts/init_db.py
python scripts/validate_db.py
python scripts/generate_markdown.py
python scripts/make_chat_digest.py