# HPSC Database Improvement Suggestions

## Table of contents

- [Suggested Next Additions (optional)](#suggested-next-additions-optional)
- [Integrity strategy (MySQL)](#integrity-strategy-mysql)
    - [Delete and Update Rules](#delete-and-update-rules)
- [Indexing Notes](#indexing-notes)
- [Suggested Query/View Layers (optional)](#suggested-queryview-layers-optional)
- [Operational Considerations](#operational-considerations)
- [Change management (without a migration tool)](#change-management-without-a-migration-tool)
    - [Principles](#principles)
    - [Suggested workflow](#suggested-workflow)
    - [Guardrails](#guardrails)
- [Environment configuration (MySQL)](#environment-configuration-mysql)
- [Naming and style conventions](#naming-and-style-conventions)
- [Appendix: What belongs in the authoritative schema / patches](#appendix-what-belongs-in-the-authoritative-schema--patches)

## Suggested Next Additions (optional)

- Views for leaderboards (per match, per division/category, per competitor history).
- Stored procedures or jobs to (re)compute match totals and populate log tables.
- Seed/demo data scripts for local development.

## Integrity strategy (MySQL)

### Delete and Update Rules

MySQL defaults apply unless specified. Decide early whether you want:

- **Restrict deletes** (default behaviour with FK constraints), or
  intentional `ON DELETE` policies (CASCADE / SET NULL),
  or a **soft delete** strategy

Document and apply any change deliberately (and consistently across environments).

## Indexing Notes

- Keep/extend indexes aligned with:
    - foreign key columns (for joins)
    - uniqueness constraints (already indexed by many engines)
    - common leaderboard queries (by match_id, division, competitor_id, scheduled_date)

## Suggested Query/View Layers (optional)

- `v_match_leaderboard`: ranks competitors within a match.
- `v_stage_leaderboard`: ranks competitors within a stage.
- `v_competitor_history`: competitor performance over time.
- `v_series_window`: series standings for a defined match ID window.

## Operational Considerations

- Prefer running schema changes via versioned migration files.
- Consider consistent naming for future additions (e.g. snake_case).
- If you expect row deletes, decide early:
    - restrict deletes (current FK defaults)
    - or introduce soft deletes / ON DELETE rules intentionally.

## Change management (without a migration tool)

### Principles

- Treat schema changes as code: reviewable, repeatable, and version controlled.
- Prefer small, incremental change scripts over editing the live database manually.
- Avoid editing historical change scripts after they have been applied to a shared environment.

### Suggested workflow

- Keep a baseline schema (`db/schema/schema.sql`) that can create a database from scratch.
- For each change:
    1. create a new script under `db/patches/` with the next sequence number
    2. apply it to local/dev
    3. record the applied patch number in deployment notes/runbooks
- In production, apply scripts in order and keep a record of what ran and when.

### Guardrails

- Always take a backup before applying patches in production.
- Run patches inside an explicit transaction where feasible.
- Validate the resulting schema (constraints and indexes) after applying changes.

## Environment configuration (MySQL)

At minimum you will need:

- host/port/database name
- username/password

Keep secrets out of git; use environment variables or secret managers.

## Naming and style conventions

- Prefer `snake_case` for tables and columns (current schema uses this)
- Keep constraint names stable and descriptive
- Be consistent about quoting:
    - If keeping table name `match`, always reference it as `\`match\`` in MySQL SQL scripts

## Appendix: What belongs in the authoritative schema / patches

- Table creation and changes (DDL)
- Constraints (PK/FK/UNIQUE/CHECK where supported)
- Indexes
- Views and stored procedures (if used)
- Seed/reference data (optional; keep it minimal and deterministic)

Everything should be reproducible from an empty database by applying the baseline schema and then the ordered
patch scripts.
