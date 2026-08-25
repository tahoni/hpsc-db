# Changelog

All notable changes to the HPSC Database project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## 📌 Table of Contents

- [🧪 Unreleased](#-unreleased)
- [🧾 4.1.0](#-410---2026-05-31)
- [🧾 4.0.0](#-400---2026-05-31)
- [🧾 3.2.0](#-320---2026-04-26)
- [🧾 3.1.0](#-310---2026-03-15)
- [🧾 3.0.0](#-300---2026-03-13)
- [🧾 2.0.1](#-201---2026-02-25)
- [🧾 2.0.0](#-200---2026-02-23)
- [🧾 1.1.0](#-110---2026-01-28)
- [🧾 1.0.0](#-100---2025-12-28)

---

## 🧪 [Unreleased]

### Planned

- Views for leaderboards (per match, per division/category, per competitor history)
- Stored procedures for computing match totals and populating log tables
- Seed/demo data scripts for local development
- Additional indexing optimisations for common query patterns

---

## 🧾 [4.1.0] - 2026-05-31

### Added

- **SQL Scripts**: Added `table_create-v4.1.0.sql` — unified schema creation script covering `club`,
  `competitor`, `ipsc_match`, `ipsc_match_stage`, `match_competitor` and `match_stage_competitor` and their
  associations
- **SQL Scripts**: Added `table_alter-v4.1.0.sql` — migration script relaxing `competitor` constraints,
  dropping unused columns and standardising timestamp handling
- **SQL Scripts**: Added `table_data-v4.1.0.sql` — refreshed seed data with 200+ competitor records aligned
  to the v4.1.0 schema

### Changed

- **Database Schema**: `competitor.gender` changed from `VARCHAR(36)` to `ENUM('Male', 'Female')`
- **Database Schema**: `competitor.competitor_number` relaxed from `NOT NULL` to nullable
- **Database Schema**: `date_created` / `date_updated` now default to `CURRENT_TIMESTAMP`, with
  `date_updated` auto-refreshing via `ON UPDATE CURRENT_TIMESTAMP`, on `club`, `competitor`, `ipsc_match`,
  `ipsc_match_stage`, `match_competitor` and `match_stage_competitor`
- **Seed Data**: `table_data-v4.1.0.sql` uses `NULL` instead of empty strings for unpopulated `gender`
  values to satisfy the new `ENUM` column

### Removed

- **Database Schema**: Dropped `competitor.secondary_email_address` column
- **Database Schema**: Dropped `uk_competitor_sapsa_number` unique constraint on `competitor.sapsa_number`
- **Database Schema**: Dropped `ipsc_match.date_edited` and `ipsc_match.date_refreshed` columns
- **Database Schema**: Dropped `match_competitor.date_edited` and `match_stage_competitor.date_edited`
  columns

### Improved

- **Data Integrity**: Constraint relaxations align the schema with real-world club data, where SAPSA
  numbers and competitor numbers are frequently missing or duplicated
- **Schema Clarity**: Removing unused and superseded columns reduces schema surface area
- **Timestamp Management**: `date_created` / `date_updated` are now managed automatically by the database
  instead of requiring application code to set them

### Breaking Changes

- `competitor.secondary_email_address` removed — back up this data before upgrading if still required
- `competitor.gender` is now an `ENUM('Male', 'Female')` — existing free-text values outside those two must
  be cleaned up before migrating
- `uk_competitor_sapsa_number` uniqueness is no longer enforced by the database
- `date_edited` / `date_refreshed` columns removed from `ipsc_match`, `match_competitor` and
  `match_stage_competitor` — use `date_updated` instead

### Migration Notes

For existing installations upgrading from v4.0.0:

1. Back up your database
2. Review existing `competitor.gender` values and clean up anything outside `'Male'` / `'Female'`
3. Apply the migration script: `scripts/table_alter-v4.1.0.sql`

For new v4.1.0 installations:
- Use `scripts/table_create-v4.1.0.sql` for direct schema creation
- (Optional) Use `scripts/table_data-v4.1.0.sql` for preloaded competitor seed data

---

## 🧾 [4.0.0] - 2026-05-31

### Added

- **SQL Scripts**: Added `table_create-v4.0.0.sql` — comprehensive, freshly versioned schema creation script
  for v4.0.0 implementations
- **SQL Scripts**: Added `table_alter-v4.0.0.sql` — migration script extending the competitor table with
  7 new contact and identification fields
- **SQL Scripts**: Added `table_data-v4.0.0.sql` — comprehensive seed data with 200+ competitor records
  including full contact details and SAPSA membership information
- **Database Schema**: Added 7 new columns to `competitor` table:
  - `nickname` — Optional nickname/short name
  - `gender` — Gender classification
  - `club_number` — Club-specific competitor number (unique constraint: `uk_competitor_club_number`)
  - `id_number` — National identity/passport number
  - `cellphone_number` — Primary mobile phone contact
  - `email_address` — Primary email address
  - `secondary_email_address` — Secondary email address

### Changed

- **SQL Scripts**: Updated `table_alter-v3.2.0.sql` with clear date markers and descriptive comments

### Improved

- **Competitor Information Management**: Extended competitor profiles support comprehensive contact and
  identification tracking for compliance and multichannel communication
- **Schema Versioning**: Fresh v4.0.0 schema creation eliminates the need for sequential migration script
  application for new deployments
- **Competitor Coverage**: Pre-loaded 200+ competitor records with verified SAPSA membership information
  for immediate operational readiness

### Breaking Changes

- None.

### Migration Notes

For existing installations upgrading from v3.2.0:

1. Back up your database
2. Apply the migration script: `scripts/table_alter-v4.0.0.sql`
3. (Optional) Merge competitor data from `scripts/table_data-v4.0.0.sql`:
    - Review seed data to avoid SAPSA number or club number duplicates
    - Insert only new competitor records relevant to your environment

For new v4.0.0 installations:
- Use `scripts/table_create-v4.0.0.sql` for direct schema creation
- (Optional) Use `scripts/table_data-v4.0.0.sql` for preloaded competitor seed data

---

## 🧾 [3.2.0] - 2026-04-26

### Added

- **SQL Scripts**: Added `table_alter-v3.2.0.sql` — adds `uk_competitor_sapsa_number` UNIQUE constraint
  on `competitor.sapsa_number`

### Changed

- **SQL Scripts**: Renamed `table_create_v1.1.0.sql` to `table_create-v1.1.0.sql` for consistent
  hyphen-separated version naming
- **SQL Scripts**: Renamed `table_create_v3.0.0.sql` to `table_create-v3.0.0.sql` for consistent
  hyphen-separated version naming
- **SQL Scripts**: Renamed `table_data_v1.1.0.sql` to `table_data-v1.1.0.sql` for consistent
  hyphen-separated version naming
- **SQL Scripts**: Renamed `table_delete_ipsc_match_v3.0.0.sql` to `table_delete-ipsc_match-v3.0.0.sql`
  for consistent hyphen-separated version naming
- **SQL Scripts**: Renamed `table_drop_v3.0.0.sql` to `table_drop-v3.0.0.sql` for consistent
  hyphen-separated version naming
- **SQL Scripts**: Extended `table_delete-ipsc_match-v3.0.0.sql` to also delete all `competitor` rows
  within the same transaction
- **SQL Scripts**: Updated comment reference in `table_alter-v2.0.0.sql` from `table_create_v1.1.0.sql`
  to `table_create-v1.1.0.sql`
- **Documentation**: Updated script-name references across `CHANGELOG.md`, `HISTORY.md`,
  `documentation/archive/ARCHIVE.md`, and all historical versioned release notes

### Fixed

- Inconsistent script filename references using underscores instead of hyphens across all documentation
  and historical release notes

### Breaking Changes

- None.

### Migration Notes

- Update local automation and onboarding runbooks to use the renamed scripts:
    - `scripts/table_create-v1.1.0.sql`
    - `scripts/table_create-v3.0.0.sql`
    - `scripts/table_data-v1.1.0.sql`
    - `scripts/table_delete-ipsc_match-v3.0.0.sql`
    - `scripts/table_drop-v3.0.0.sql`
- Note that `scripts/table_delete-ipsc_match-v3.0.0.sql` now also deletes all `competitor` rows — review
  any automation relying on this script for data scope changes.

---

## 🧾 [3.1.0] - 2026-03-15

### Added

- **SQL Scripts**: Added `table_delete-ipsc_match-v3.0.0.sql` for transactional, foreign-key-safe deletion of
  `ipsc_match` data and dependent match result records

### Changed

- **SQL Scripts**: Renamed `table_create_v1.0.0.sql` to `table_create-v1.1.0.sql` for version-aligned
  baseline naming
- **SQL Scripts**: Renamed `table_data.sql` to `table_data-v1.1.0.sql` for version-aligned seed data naming
- **SQL Scripts**: Updated comment reference in `table_alter-v2.0.0.sql` from `table_create_v1.0.0.sql` to
  `table_create-v1.1.0.sql`
- **Documentation**: Updated script-name references in release-history files and changelog/history entries
  to match renamed v1.1.0 scripts

### Fixed

- Inconsistent historical references to legacy script filenames across documentation and release notes

### Breaking Changes

- None.

### Migration Notes

- Update local automation and onboarding runbooks to use:
    - `scripts/table_create-v1.1.0.sql`
    - `scripts/table_data-v1.1.0.sql`
- Use `scripts/table_delete-ipsc_match-v3.0.0.sql` for full match-data clean-up in v3.0.0 schema
  environments.

---

## 🧾 [3.0.0] - 2026-03-13

### Added

- **SQL Scripts**: Added `table_drop-v3.0.0.sql` for foreign-key-safe teardown of current schema tables
- **SQL Scripts**: Added `table_drop-v3.0.0.sql` for foreign-key-safe teardown of legacy v1.0.0 tables

### Changed

- **Database Schema**: Removed global uniqueness enforcement on `ipsc_match.name`
- **SQL Scripts**: Added dynamic metadata-based index lookup before dropping the unique index/constraint on
  `ipsc_match.name`

### Fixed

- Schema migration reliability in environments where unique index names differ for `ipsc_match.name`

### Breaking Changes

- ⚠️ **`ipsc_match.name` is no longer globally unique** – applications must not rely on name-only uniqueness

### Migration Notes

```sql
-- Migration for version 3.0.0

-- Drop the unique constraint/index on ipsc_match.name (if present)
SET @ipsc_match_name_unique_idx := (SELECT s.INDEX_NAME
                                    FROM INFORMATION_SCHEMA.STATISTICS s
                                    WHERE s.TABLE_SCHEMA = DATABASE()
                                      AND s.TABLE_NAME = 'ipsc_match'
                                      AND s.COLUMN_NAME = 'name'
                                      AND s.NON_UNIQUE = 0
                                    LIMIT 1);

SET @ipsc_match_drop_unique_sql := IF(
        @ipsc_match_name_unique_idx IS NOT NULL,
        CONCAT('ALTER TABLE ipsc_match DROP INDEX `', @ipsc_match_name_unique_idx, '`'),
        'SELECT ''No unique index found on ipsc_match.name'''
                                   );

PREPARE stmt_drop_ipsc_match_name_unique FROM @ipsc_match_drop_unique_sql;
EXECUTE stmt_drop_ipsc_match_name_unique;
DEALLOCATE PREPARE stmt_drop_ipsc_match_name_unique;
```

---

## 🧾 [2.0.1] - 2026-02-25

### Changed

- **Documentation**: Refined formatting and structure across release notes, history, and archive references
- **Documentation**: Added consolidated release notes index and navigation guides in `documentation/history/`
- **SQL Scripts**: Standardised comment wording for timestamp normalisation in `table_alter-v2.0.0.sql`

### Fixed

- Inconsistent headings and formatting in release documentation for clearer navigation

---

## 🧾 [2.0.0] - 2026-02-23

### Added

- **Database Schema**: New `date_refreshed` column to `ipsc_match` table for tracking data synchronisation
  (2026-02-14)
- **Database Schema**: New `date_refreshed` column to `match_competitor` table for tracking record updates
  (2026-02-15)
- **Database Schema**: New `date_refreshed` column to `match_stage_competitor` table for tracking score
  refreshes (2026-02-15)
- **Documentation**: CHANGELOG.md for structured version tracking following Keep a Changelog format
- **Documentation**: RELEASE_NOTES.md template aligned with modern documentation practices
- **Documentation**: HISTORY.md with comprehensive release history and narrative descriptions for each version
- **Documentation**: Versioned release notes (v2.0.1, v2.0.0, v1.1.0, v1.0.0) in `documentation/history/`
  directory

### Changed

- **SQL Scripts**: Consolidated schema modification scripts in `table_alter-v2.0.0.sql` with chronological
  date
  markers
- **SQL Scripts**: Enhanced `schema.sql` with proper user and schema creation for development and production
- **SQL Scripts**: Updated `table_data-v1.1.0.sql` with corrected club names for seed data
- **Licence**: Changed LICENCE.md from proprietary "All Rights Reserved" to MIT Licence for open source
  distribution
- **Documentation**: Enhanced SUGGESTIONS.md with additional guidance on change management
- **Documentation**: Improved README.md structure and content organisation

### Removed

- **Database Schema**: `club_name` column from `ipsc_match` table to enforce referential integrity
  (2026-02-21)
- **Database Schema**: `club` column from `match_competitor` table to reduce data duplication
  (2026-02-21)

### Fixed

- Data consistency issues by removing denormalised `club_name` columns
- SQL script formatting and dialect consistency across all scripts
- **match_competitor table**: Removed redundant `club` column to enforce proper club information retrieval via
  foreign key relationships with the club table

### Breaking Changes

- ⚠️ **Removed `ipsc_match.club_name` column** - Applications must now use `club_id` foreign key relationship
- ⚠️ **Removed `match_competitor.club` column** - Applications must retrieve club information via JOIN
  operations
- **Migration Required**: Update all queries to use JOIN operations for club information retrieval

### Migration Notes

```sql
-- Migration for version 2.0.0

-- Step 1: Add date_refreshed columns (2026-02-14, 2026-02-15)
ALTER TABLE ipsc_match
    ADD COLUMN date_refreshed DATETIME NULL;
ALTER TABLE match_competitor
    ADD COLUMN date_refreshed DATETIME NULL;
ALTER TABLE match_stage_competitor
    ADD COLUMN date_refreshed DATETIME NULL;

-- Step 2: Remove redundant columns (2026-02-21)
ALTER TABLE ipsc_match
    DROP COLUMN club_name;
ALTER TABLE match_competitor
    DROP COLUMN club;
```

### Deprecated

- Direct storage of `club_name` in result tables (removed in this version)

---

## 🧾 [1.1.0] - 2026-01-28

### Added

- **Database Schema**: Initial schema creation with core domain tables
- **Database Schema**: Participation and scoring tables for match results
- **Database Schema**: Foreign key constraints for referential integrity
- **Documentation**: Comprehensive `ARCHITECTURE.md` with design principles
- **Documentation**: Enhanced `README.md` with project overview and quick start guide
- **SQL Scripts**: `table_create-v1.1.0.sql` with complete table definitions
- **SQL Scripts**: `schema.sql` for database and user setup
- **SQL Scripts**: `table_data-v1.1.0.sql` with initial seed data for clubs

### Changed

- Improved table naming conventions for clarity
- Enhanced foreign key relationships for better data integrity

---

## 🧾 [1.0.0] - 2025-12-28

### Added

- **Initial Release**: HPSC Database project initialisation
- **Database Schema**: Core tables for clubs, competitors, matches, and stages
- **Database Schema**: Result tracking tables for match and stage performance
- **Database Schema**: Logging tables for derived standings
- **Documentation**: Initial `README.md` with project description
- **Documentation**: `LICENCE.md` with copyright information
- **Documentation**: `suggestions.md` with improvement roadmap
- **SQL Scripts**: Basic schema creation scripts
- **Repository**: Git repository initialisation with `.gitignore` configuration

### Technical Details

- **Database**: MySQL 8.x with InnoDB storage engine
- **Character Set**: utf8mb4 with `utf8mb4_0900_ai_ci` collation
- **Architecture**: Database-first design with normalised relational schema

---

## 🔗 Version Comparison Links

- 4.0.0 vs 3.2.0: `git log v3.2.0...v4.0.0`
- 3.2.0 vs 3.1.0: `git log v3.1.0...v3.2.0`
- 3.1.0 vs 3.0.0: `git log v3.0.0...v3.1.0`
- 3.0.0 vs 2.0.1: `git log v2.0.1...v3.0.0`
- 2.0.1 vs 2.0.0: `git log v2.0.0...v2.0.1`
- 2.0.0 vs 1.1.0: `git log v1.1.0...v2.0.0`
- 1.1.0 vs 1.0.0: `git log v1.0.0...v1.1.0`

---

## 🤝 Contributing

When adding new versions to this changelog:

1. Add a new section under [Unreleased](#-unreleased) with the format: `## [X.Y.Z] - YYYY-MM-DD`
2. Move relevant items from the Unreleased section to the new version
3. Organise changes under appropriate categories:
    - **Added** – New features or functionality
    - **Changed** – Changes to existing functionality
    - **Deprecated** – Features marked for removal in future versions
    - **Removed** – Features removed in this version
    - **Fixed** – Bug fixes
    - **Security** – Security vulnerability fixes
    - **Breaking Changes** – Changes that break backward compatibility
    - **Migration Notes** – SQL or code changes required for upgrading
4. Update the Table of Contents with the new version

---

## 📐 Semantic Versioning Guide

- **Major version (X.0.0)**: Breaking changes, incompatible API/schema changes
- **Minor version (X.Y.0)**: New features, backward-compatible additions
- **Patch version (X.Y.Z)**: Bug fixes, backward-compatible fixes

---

## 📚 Additional Resources

- [Release Notes](RELEASE_NOTES.md) – Detailed release information for version 3.2.0
- [Architecture Documentation](ARCHITECTURE.md) – Database architecture and design principles
- [Project Overview](README.md) – Getting started and project introduction
- [Improvement Suggestions](documentation/roadmap/SUGGESTIONS.md) – Future enhancements and roadmap

---

**Maintainer**: Leoni Lubbinge (leonil@tahoni.info)



