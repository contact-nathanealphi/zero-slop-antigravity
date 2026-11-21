---
name: db-schema-guard
description: Guard database schema, ORM, and migration changes, and block destructive commands without explicit confirmation.
---

- Triggered when touching a database, query, ORM, or migration.
- Never open or search SQL dump files (`*.sql` or `*.sql.gz`).
- Use only `migrations/`, `schema`, ORM models, or light queries (`DESCRIBE` / `SHOW TABLES`).
- Always ask for explicit confirmation before a destructive command (`DROP`, `TRUNCATE`, `migrate:fresh`, or `DELETE` without `WHERE`).
