# Initial-profile refactor

This package changes the rebuild model to:

1. `sql/schema.sql`
2. `sql/insert_targets.sql`
3. `sql/initial_profile.sql`
4. every canonical `updates_logs/eval_NNN.sql` file in filename order
5. generated `PROFILE.md` from the resulting database

The old `sql/current_profile.sql` is no longer an input and should be removed.

Commands:

```bash
rm -f sql/current_profile.sql
python scripts/init_db.py
python scripts/validate_db.py
python scripts/generate_markdown.py
python scripts/make_chat_digest.py
```
