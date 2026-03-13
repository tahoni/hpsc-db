# HPSC Database - Legacy Release Archive

> **Note:** This archive contains the history of releases from the legacy non-semantic versioning structure
> that was previously used for this project. This versioning approach is no longer active and has been
> superseded by [Semantic Versioning (SemVer)](https://semver.org/) as of version 2.0.0.
>
> **The v1.x.x release notes below are historical records only.** For current release information and active
> version history, please refer to:
> - [Current Release Notes](../../RELEASE_NOTES.md)
> - [Release History](../history/RELEASE_NOTES_HISTORY.md)
> - [Changelog](../../CHANGELOG.md)
> - [History Document](../../HISTORY.md)

## Releases

### Table of Contents

- [Version 1.2.0](#version-120---_2026-02-21_)
- [Version 1.1.0](#version-110---_2026-02-03_)
- [Version 1.0.0](#version-100---_2026-01-28_)

### Version 1.2.0 - _2026-02-21_

This release updates the database schema scripts and documentation templates as part of the IPSC workstream.
Key improvements include refreshed match table data handling, restored join tables, and removal of unnecessary
tables.

#### Database Schema Changes

**Added / Restored**

- Restored required join tables to support domain relationships

**Updated**

- Refreshed data updates for the `match` table
- Updated schema generation and migration scripts:
    - `scripts/table_create_v1.0.0.sql`
    - `scripts/table_alter-v2.0.0.sql`

**Removed**

- Removed unnecessary tables from the schema

#### Schema Enhancements

**Competitor**

- Made `sapsa_number` optional (nullable, `varchar(255)`)
- Added `place` (nullable) to store competitor placing

**Match Competitor**

- Added `is_disqualified` (nullable boolean) for match-level DQ tracking
- Added `place` (nullable) for match-level placing

**Match Stage Competitor**

- Added per-stage score buckets: `score_a`, `score_b`, `score_c`, `score_d` (nullable integers)
- Added penalty detail fields: `misses`, `procedurals` (nullable integers)
- Added `is_disqualified` (nullable boolean) for stage-level DQ tracking

#### Documentation & Configuration

- Created `README.md` and `ARCHITECTURE.md`
- Added documentation templates: `CHANGELOG.md` and `RELEASE_NOTES.md`
- Added `suggestions.md` for future enhancements
- Updated `.gitignore` and IDE configuration (`.idea/`)
- Removed `db-forest-config.xml`

#### Migration Guide

**For new environments:** Use `scripts/table_create_v1.0.0.sql`

**For existing environments:** Apply `scripts/table_alter-v2.0.0.sql` against databases based on the `main`
branch
schema

**Post-migration validation:**

- Verify expected join tables exist
- Confirm removed tables are not referenced by downstream queries/jobs
- Validate `match` table data is refreshed as intended

#### Known Considerations

- `.idea/` changes are environment-specific; confirm whether your workflow expects these files to be tracked

#### Changes by

@tahoni

### Version 1.1.0 - _2026-02-03_

This release introduces several schema enhancements to support improved match and stage scoring, placing, and
disqualification tracking. It also includes documentation updates and configuration improvements.

### Database schema changes (MySQL)

#### Match

- Allow matches without a club by making `match.club_id` nullable.
- Add audit timestamps:
    - `match.date_created` (nullable `datetime`)
    - `match.date_updated` (nullable `datetime`)

#### Match stage

- Add `match_stage.stage_name` (nullable `varchar(255)`)

#### Match stage competitor

- Add scoring deduction support:
    - `has_deduction` (nullable `int`)
    - `deduction_percentage` (nullable `decimal(10,2)`)
- Add audit timestamp:
    - `date_updated` (nullable `datetime`)
- (Also includes earlier addition) `is_disqualified` (nullable `boolean`)

#### Match competitor

- Add audit timestamp:
    - `match_competitor.date_updated` (nullable `datetime`)

### Developer/Tooling

- Configure IDE SQL dialect mapping so `scripts/table_alter-v2.0.0.sql` is recognised as MySQL (in
  `.idea/sqldialects.xml`).

### Upgrade notes

- Apply the new statements in `scripts/table_alter-v2.0.0.sql` to bring an existing `version-1.0.0` database
  up to
  `version-1.1.0`.
- If your application layer assumes `match.club_id` is always present, update validation/queries to handle
  `NULL`.

### Changes by

@tahoni

### Version 1.0.0 - _2026-01-28_

Extended the database schema to better support match/stage scoring, placing, and disqualification tracking.

#### Enhancements and Updates

- **Competitor**
    - Make `sapsa_number` optional (nullable, stored as `varchar(255)`).
    - Add `place` (nullable) to store competitor placing where relevant.

- **Match competitor**
    - Add `is_disqualified` (nullable boolean) to flag DQ status at match level.
    - Add `place` (nullable) for match-level placing.

- **Match stage competitor**
    - Add per-stage score buckets: `score_a`, `score_b`, `score_c`, `score_d` (nullable ints).
    - Add penalty detail fields: `misses`, `procedurals` (nullable ints).
    - Add `is_disqualified` (nullable boolean) for stage-level DQ tracking.

#### Licence and Documentation

- Created the `README.md` and `ARCHITECTURE.md` files.
- Added documentation templates for `CHANGELOG.md` and `RELEASE_NOTES.md`.
- Added a `suggestions.md` file for future enhancements.

#### Changes by

@tahoni
