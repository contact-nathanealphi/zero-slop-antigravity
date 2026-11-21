---
name: db-schema-guard
description: Use when touching a database, query, ORM model, or migration. Blocks dumps and destructive commands without explicit confirmation.
---

- Never open or search dumps: `*dump*.sql`, `*.sql.gz`, `*.sqlite*`, `backups/`.
- Migration files (including `migrations/*.sql`), schema files, and ORM models are readable.
- Live DB: read-only introspection only (`DESCRIBE`, `SHOW TABLES`, `\d`).
- Always ask before `DROP`, `TRUNCATE`, `ALTER ... DROP COLUMN`, `DELETE` / `UPDATE` without `WHERE`, `migrate:fresh`, reset / force-push schema commands, or anything on a non-local database. State the target DB and expected impact. Plan approval does not count as confirmation.
- Never edit an already-applied migration; add a new one with a rollback path. Never print connection strings.
