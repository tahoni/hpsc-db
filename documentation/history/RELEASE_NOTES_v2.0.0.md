# Release Notes

## Version 2.0.0

**Release Date:** February 23, 2026
**Branch:** develop → main

---

## 📌 Overview

This release introduces significant database schema improvements, enhanced SQL script organisation, and
documentation template updates for the HPSC Database. The changes focus on better data tracking capabilities,
improved referential integrity, and streamlined schema management.

---

## ✨ What's New

### 🗄️ Database Schema Enhancements

#### Table Creation (2026-02-01 to 2026-02-15)

- **Core Tables**: Created comprehensive database schema with 6 main tables and 6 join tables
    - `club`: Organisation information with a unique constraint on name
    - `ipsc_match`: Match details with club relationships and scheduling information
    - `competitor`: Competitor profiles with SAPSA numbers and personal details
    - `ipsc_match_stage`: Stage configuration with target counts and scoring parameters
    - `match_competitor`: Competitor match participation and overall results
    - `match_stage_competitor`: Detailed stage-level performance data

- **Join Tables**: Established proper many-to-many relationships
    - `club_matches`, `ipsc_match_match_stages`, `ipsc_match_match_competitors`
    - `ipsc_match_stage_match_stage_competitors`, `competitor_competitor_matches`,
      `competitor_competitor_stage_matches`

#### Schema Modifications (2026-02-14 to 2026-02-21)

- **Added `date_refreshed` columns** (2026-02-14, 2026-02-15):
    - `ipsc_match.date_refreshed` - Track when match data was last synchronised
    - `match_competitor.date_refreshed` - Track when competitor match data was last updated
    - `match_stage_competitor.date_refreshed` - Track when stage results were last refreshed
    - All columns are nullable DATETIME fields for external data source tracking

- **Removed redundant `club_name` columns** (2026-02-21):
    - `ipsc_match.club_name` - Eliminated to enforce foreign key relationship to club table
    - `match_competitor.club` - Removed to reduce data duplication and improve data integrity

### 📋 SQL Script Organisation

#### Improved Script Structure

- **`table_alter-v2.0.0.sql`**: Consolidated schema modification scripts with clear date markers for change
  tracking
- **`table_create_v1.0.0.sql`**: Maintained comprehensive table creation scripts with proper foreign key
  constraints
- **`table_data.sql`**: Updated seed data with corrected club names
- **`schema.sql`**: Enhanced with proper user and schema creation for both development and production
  environments

### 📚 Documentation Improvements

#### New Documentation Templates

- **CHANGELOG.md**: Introduced a structured changelog format following Keep a Changelog standards for version
  tracking and documentation
- **RELEASE_NOTES.md**: Established standardised release notes format aligned with modern documentation
  practices
- **HISTORY.md**: Added comprehensive release history with narrative descriptions for each version
- **Versioned Release Notes**: Created historical release notes (v2.0.0, v1.1.0, v1.0.0) in
  `documentation/history/` directory

#### Updated Documentation

- **LICENCE.md**: Changed from proprietary "All Rights Reserved" to MIT Licence for open source distribution
- **README.md**: Maintained comprehensive project overview with table of contents and quick start guides
- **ARCHITECTURE.md**: Preserved detailed architectural documentation with MySQL-specific considerations
- **SUGGESTIONS.md**: Enhanced improvement suggestions with additional guidance on change management

---

## ⚠️ Breaking Changes

### Schema Changes

**Removed Columns**

- `ipsc_match.club_name` - Use `club_id` foreign key relationship instead
- `match_competitor.club` - Use `match_id` → `club_id` relationship instead
  **Migration Path:**
  Applications should now retrieve club information via proper JOIN operations:

```sql
-- Old approach (no longer supported):
SELECT club_name
FROM ipsc_match;

-- New approach:
SELECT c.name, c.abbreviation
FROM ipsc_match m
         JOIN club c ON m.club_id = c.id;
```

---

## 🐛 Bug Fixes

- Fixed data consistency issues by removing denormalised `club_name` columns
- Corrected SQL script formatting and dialect consistency
- **match_competitor table**: Removed redundant `club` column to enforce proper club information retrieval via
  foreign key relationships with the club table

---

## 🚀 Improvements

### 🔐 Data Integrity

- Enhanced referential integrity by enforcing club relationships through foreign keys only
- Added temporal tracking capabilities with `date_refreshed` columns
- Improved audit trail for data synchronisation operations

### 📝 Code Quality

- Organised schema change scripts with chronological date markers
- Improved SQL script readability and maintainability
- Added proper documentation for schema evolution

### 👨‍💻 Developer Experience

- Clearer separation between development and production schemas
- Better structured SQL migration files
- Enhanced documentation templates for future releases
- **MIT Licence adoption**: Transitioned to open source licensing for wider community adoption
- **Organised documentation structure**: Established `documentation/history/` directory for versioned
  release
  notes
- **Comprehensive version history**: Created CHANGELOG.md and HISTORY.md for better version tracking

---

## 🔧 Technical Details

### Database Changes

#### Tables Created (Complete Schema)

**Core Tables:**

- `club`: Club/organisation management with unique name and abbreviation constraints
- `ipsc_match`: Match scheduling and configuration with a foreign key to club
- `competitor`: Competitor profiles with SAPSA number and personal information
- `ipsc_match_stage`: Stage details including target counts (paper, popper, plates, disappear, penalty) and
  scoring parameters
- `match_competitor`: Match participation records with division, power factor, and overall match results
- `match_stage_competitor`: Detailed stage performance including hit factor, stage points, and ranking
  **Join Tables:**

- `club_matches`: Links clubs to their hosted matches
- `ipsc_match_match_stages`: Links matches to their stages
- `ipsc_match_match_competitors`: Links matches to competitors
- `ipsc_match_stage_match_stage_competitors`: Links stages to stage results
- `competitor_competitor_matches`: Links competitors to their match participants
- `competitor_competitor_stage_matches`: Links competitors to their stage results

#### Tables Modified

- `ipsc_match`: Added `date_refreshed DATETIME NULL`, removed `club_name VARCHAR(255)`
- `match_competitor`: Added `date_refreshed DATETIME NULL`, removed `club VARCHAR(255)`
- `match_stage_competitor`: Added `date_refreshed DATETIME NULL`

#### Key Features

- **Auto-increment primary keys**: All tables use `BIGINT PRIMARY KEY AUTO_INCREMENT`
- **Automatic timestamps**: `date_created` and `date_updated` columns with automatic timestamp management
- **Foreign key constraints**: Proper referential integrity across all relationships
- **Unique constraints**: Enforced on club names and match names
- **Audit fields**: `date_edited` and `date_refreshed` for change tracking

#### Schema Scripts Updated

- `scripts/schema.sql`: Database and user creation with proper permissions
- `scripts/table_create_v1.0.0.sql`: Core table definitions with foreign key constraints
- `scripts/table_alter-v2.0.0.sql`: Chronological schema modifications
- `scripts/table_data.sql`: Updated seed data for clubs

### Dependencies

**Database Requirements:**

- MySQL 8.x
- InnoDB storage engine
- utf8mb4 character set
- utf8mb4_0900_ai_ci collation

---

## 📦 Upgrade Guide

### For New Installations

1. Run `scripts/schema.sql` to create databases and users
2. Run `scripts/table_create_v1.0.0.sql` to create all tables
3. Run `scripts/table_data.sql` to insert initial seed data

### For Existing Installations

1. **Backup your database** before applying changes
2. Update application code to remove references to `club_name` columns
3. Run the following migration scripts in order:
   ```sql
   -- Add date_refreshed columns (2026-02-14, 2026-02-15)
   ALTER TABLE ipsc_match ADD COLUMN date_refreshed DATETIME NULL;
   ALTER TABLE match_competitor ADD COLUMN date_refreshed DATETIME NULL;
   ALTER TABLE match_stage_competitor ADD COLUMN date_refreshed DATETIME NULL;

   -- Remove redundant club_name columns (2026-02-21)
   ALTER TABLE ipsc_match DROP COLUMN club_name;
   ALTER TABLE match_competitor DROP COLUMN club;
   ```
4. Update application queries to use JOIN operations for club information
5. Test all functionality thoroughly

---

## ℹ️ Known Issues

None at this time.

---

## 📢 Deprecations

- Direct storage of `club_name` in `ipsc_match` and `match_competitor` tables (removed)

---

## 👥 Contributors

**Leoni Lubbinge** - Database architecture and implementation

---

## 🔗 Additional Resources

- [Architecture Documentation](../../ARCHITECTURE.md) - Detailed database architecture, design principles, and
  technical requirements
- [Project Overview & Quick Start Guide](../../README.md) – Introduction to the HPSC Database with schema
  entities,
  conventions, and typical workflows
- [Improvement Suggestions](../roadmap/SUGGESTIONS.md) - Future enhancements, indexing strategies,
  and change management best practices

---

## 💬 Feedback

For questions, issues, or suggestions, please contact:

- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---
**Full Changelog**: main vs develop - `git log main..develop`
