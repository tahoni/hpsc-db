# Release Notes

## Version 1.1.0

**Release Date:** January 28, 2026
**Branch:** develop → main

---

## 📌 Overview

This release focuses on schema maturity and comprehensive documentation, establishing a solid foundation for
the HPSC Database with complete table definitions, foreign key constraints, and detailed architectural
documentation. The release transforms the initial prototype into a production-ready database schema.

---

## ✨ What's New

### 🗄️ Database Schema Enhancements

#### Complete Schema Definition

- **Core domain tables**: Finalised definitions for `club`, `competitor`, `match`, and `match_stage` tables
  with proper data types and constraints
- **Participation tables**: Implemented `match_competitor` to track competitor participation in matches with
  division, discipline, and power factor
- **Scoring tables**: Created `match_stage_competitor` for detailed stage-level performance tracking including
  points, penalties, time, and hit factors
- **Join tables**: Added relationship tables for managing one-to-many associations between entities

#### Foreign Key Constraints

- **Referential integrity**: Implemented foreign key constraints across all tables to enforce data consistency
- **Cascade relationships**: Established proper parent-child relationships between matches, stages, and
  results
- **Constraint naming**: Applied consistent naming conventions for all foreign key constraints

### 📋 SQL Script Organisation

#### Core Scripts Established

- **`table_create_v1.0.0.sql`**: Comprehensive table creation script with all entity definitions and
  constraints
- **`schema.sql`**: Database and user creation scripts for development and production environments
- **`table_data.sql`**: Initial seed data for clubs (HPSC, PMPSC, SOSC)

### 📚 Documentation Improvements

#### New Documentation

- **ARCHITECTURE.md**: Comprehensive architectural documentation including:
    - Target database specifications (MySQL 8.x, InnoDB, utf8mb4)
    - Data model overview with entity descriptions
    - Key relationships and integrity strategy
    - Aggregation strategy (compute-and-store approach)

- **Enhanced README.md**: Improved project overview with:
    - Table of contents for easy navigation
    - Schema entities descriptions
    - Quick start guide for DataGrip
    - Conventions and constraints documentation
    - Typical workflows supported by the schema

- **suggestions.md**: Initial improvement suggestions including:
    - Future enhancements roadmap
    - Integrity strategy guidelines
    - Indexing recommendations
    - Query/view layer suggestions

---

## ⚠️ Breaking Changes

None. This is a feature addition release with no breaking changes.

---

## 🐛 Bug Fixes

- Initial release – no bug fixes applicable

---

## 🚀 Improvements

### 🔐 Data Integrity

- Implemented foreign key constraints to prevent orphaned records
- Added uniqueness constraints to prevent duplicate entries
- Established proper referential integrity across all entity relationships

### 📝 Code Quality

- Organised SQL scripts with clear separation of concerns
- Implemented consistent naming conventions (snake_case for columns, InnoDB for storage)
- Added comprehensive inline comments for complex relationships

### 👨‍💻 Developer Experience

- Created a quick start guide for DataGrip users
- Documented conventions and constraints for developers
- Provided seed data for immediate testing and development
- Established clear project structure with organised directories

---

## 🔧 Technical Details

### Database Changes

#### Tables Created

**Core Domain:**

- `club`: Organisation entity with name and abbreviation
- `competitor`: Athlete/person entity with identity fields and SAPSA number
- `ipsc_match`: Scheduled event entity hosted by clubs
- `ipsc_match_stage`: Stage definition within matches

**Results:**

- `match_competitor`: Competitor participation in matches with division/discipline
- `match_stage_competitor`: Stage-level performance with detailed scoring

**Join Tables:**

- `club_matches`: Club to matches relationship
- `ipsc_match_match_stages`: Match to stages relationship
- `ipsc_match_match_competitors`: Match to competitors relationship
- `competitor_competitor_matches`: Competitor to match results relationship
- `competitor_competitor_stage_matches`: Competitor to stage results relationship

#### Schema Features

- Auto-increment primary keys on all tables
- Timestamp tracking (`date_created`, `date_updated`) on all entities
- Optional edit timestamps for audit trails
- Support for match divisions, disciplines, power factors, and categories

### Dependencies

**Database Requirements:**

- MySQL 8.x or compatible
- InnoDB storage engine
- utf8mb4 character set
- utf8mb4_0900_ai_ci collation

---

## Installation Guide

### For New Installations

1. Ensure MySQL 8.x is installed and running
2. Run `scripts/schema.sql` to create databases and users:
    - Creates `hpsc_dev` and `hpsc_prod` schemas
    - Creates corresponding users with appropriate permissions
3. Select your target schema (dev or prod)
4. Run `scripts/table_create_v1.0.0.sql` to create all tables with constraints
5. Run `scripts/table_data.sql` to insert initial club seed data
6. Verify installation in DataGrip Database Explorer

### Verification Steps

1. Check that all tables are created with proper primary keys
2. Verify foreign key relationships in the database diagram view
3. Confirm seed data is present in `club` table
4. Test inserting sample match and competitor data

---

## ℹ️ Known Issues

None at this time.

---

## 📢 Deprecations

None. This is an initial feature release.

---

## 👥 Contributors

**Leoni Lubbinge** - Database architecture and implementation

---

## 🔗 Additional Resources

- [Architecture Documentation](../../ARCHITECTURE.md) - Detailed database architecture, design principles, and
  technical requirements
- [Project Overview & Quick Start Guide](../../README.md) – Introduction to the HPSC Database with schema
  entities, conventions, and typical workflows
- [Improvement Suggestions](../roadmap/SUGGESTIONS.md) - Future enhancements, indexing strategies, and change
  management best practices
- [Changelog](../../CHANGELOG.md) – Complete version history with categorised changes

---

## 💬 Feedback

For questions, issues, or suggestions, please contact:

- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---

**Full Changelog**: v1.0.0 vs v1.1.0 `git log v1.0.0..v1.1.0`
