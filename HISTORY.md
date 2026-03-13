# Release History

This document provides a historical overview of all HPSC Database releases, with descriptions of the key
themes and objectives for each version.

---

## 📌 Table of Contents

- [🧭 Version 3.0.0 - Schema Maintenance & Migration Reliability](#-version-300---schema-maintenance--migration-reliability)
- [🧭 Version 2.0.1 - Documentation & Release Hygiene](#-version-201---documentation--release-hygiene)
- [🧭 Version 2.0.0 - Schema Refinement & Data Integrity](#-version-200---schema-refinement--data-integrity)
- [🧭 Version 1.1.0 – Enhanced Schema & Documentation](#-version-110--enhanced-schema--documentation)
- [🧭 Version 1.0.0 – Initial Release](#-version-100--initial-release)
- [🧭 Release Versioning Strategy](#-release-versioning-strategy)
    - [🧩 Version Types](#-version-types)
    - [🗺️ Version History Timeline](#-version-history-timeline)
- [🚀 Looking Forward](#-looking-forward)
    - [🛠️ Upcoming Enhancements](#-upcoming-enhancements)
    - [🔭 Long-term Vision](#-long-term-vision)
- [🔗 Additional Resources](#-additional-resources)
- [💬 Questions or Feedback?](#-questions-or-feedback)

---

## 🧭 Version 3.0.0 - Schema Maintenance & Migration Reliability

**Released:** March 13, 2026  
**Type:** Major Release (Breaking Changes)

### ✨ Release Theme

This major release focuses on **schema-maintenance reliability** and **operational reset workflows**.
The core objective is to make migrations safer across environments while providing clear teardown scripts
for repeatable setup and testing.

### 🎯 Key Objectives

1. **Relax Constraint Behavior**: Remove global uniqueness enforcement on `ipsc_match.name`
2. **Improve Migration Safety**: Use dynamic index-name resolution before applying `DROP INDEX`
3. **Support Environment Resets**: Provide FK-safe drop scripts for current and legacy schemas
4. **Keep Release Artifacts Aligned**: Synchronise root and historical release documentation

### 📖 Why This Release Matters

Version 3.0.0 addresses a practical migration issue where different environments can store different
index names for equivalent unique constraints. By resolving index metadata at runtime before dropping the
constraint, migrations become more robust and less dependent on prior naming conventions.

The new versioned drop scripts also improve developer and operations workflows by making schema teardown
repeatable and explicit.

### 📋 Major Changes

- **Breaking**: `ipsc_match.name` is no longer globally unique
- **New**: `table_drop_v3.0.0.sql` for FK-safe teardown of v3.0.0 schema tables
- **New**: `table_drop_v3.0.0.sql` for FK-safe teardown of v1.0.0 schema tables
- **Improved**: `table_alter-v3.0.0.sql` uses metadata-driven index resolution for safer migration execution

### ⚠️ Impact

This release requires validation of application logic that previously relied on globally unique match names.
Consumers should use additional qualifiers (for example, club and scheduled date) where uniqueness is
required at query or business-rule level.

### 🔗 Related Documentation

- [Full Release Notes](RELEASE_NOTES.md) – Complete details for version 3.0.0
- [Versioned Release Notes](documentation/history/RELEASE_NOTES_v3.0.0.md) – Archived release notes in the
  history directory
- [Changelog Entry](CHANGELOG.md#-300---2026-03-13) – Categorised list of all changes

---

## 🧭 Version 2.0.1 - Documentation & Release Hygiene

**Released:** February 25, 2026  
**Type:** Patch Release (Documentation)

### ✨ Release Theme

This patch release focuses on **documentation polish** and **release-history navigation**, ensuring that
release information is easier to find, consistent in structure, and aligned across the project.

### 🎯 Key Objectives

1. **Improve Release Navigation**: Add consolidated indexes and quick links for release notes
2. **Standardise Formatting**: Harmonise headings and layout across changelog and history files
3. **Clarify Documentation**: Refresh release documentation for readability and consistency
4. **Minor Script Wording**: Standardise timestamp normalisation comments in schema scripts

### 📖 Why This Release Matters

Version 2.0.1 improves the usability of project documentation without changing the schema. By providing
clearer navigation and consistent formatting, the release history becomes easier to consume for both new
contributors and existing users tracking upgrades.

### 📋 Major Changes

- **Documentation**: Added consolidated release notes index and quick navigation guides
- **Documentation**: Standardised headings and formatting for clarity and consistency
- **SQL Scripts**: Normalised comment wording for timestamp-related changes

### ⚠️ Impact

No schema changes or migrations are required. This release is safe to adopt without application updates.

### 🔗 Related Documentation

- [Full Release Notes](RELEASE_NOTES.md) – Complete details for version 2.0.1
- [Changelog Entry](CHANGELOG.md#-201---2026-02-25) – Categorised list of changes
- [Release Notes Index](documentation/history/RELEASE_NOTES_HISTORY.md) – Versioned release notes

---

## 🧭 Version 2.0.0 - Schema Refinement & Data Integrity

**Released:** February 23, 2026  
**Type:** Major Release (Breaking Changes)

### ✨ Release Theme

This major release focuses on **database normalisation** and **temporal data tracking**, introducing breaking
changes to improve long-term maintainability and data integrity. The primary goal was to eliminate data
redundancy and add synchronisation tracking capabilities.

### 🎯 Key Objectives

1. **Enforce Referential Integrity**: Remove de-normalised data columns and enforce proper foreign key
   relationships
2. **Add Temporal Tracking**: Introduce timestamp tracking for data synchronisation and refresh operations
3. **Improve Schema Management**: Establish better documentation practices and migration patterns
4. **Enhance Maintainability**: Organise SQL scripts with chronological markers for easier change tracking
5. **Adopt Open Source**: Transition from proprietary licence to MIT Licence for community adoption
6. **Establish Documentation Standards**: Create comprehensive CHANGELOG, HISTORY, and versioned release notes

### 📖 Why This Release Matters

Version 2.0.0 represents a significant architectural improvement in how the database maintains data
consistency. By removing redundant `club_name` columns from result tables and enforcing JOIN operations, the
schema now follows database normalisation best practices more strictly. This prevents data inconsistencies
that could arise from duplicate club names stored across multiple tables.

In particular, the removal of the `club` column from the `match_competitor` table ensures that club
information is maintained in a single, authoritative location (the `club` table). This eliminates the risk of
data synchronisation issues where the same club could have different representations in different tables.

The addition of `date_refreshed` columns enables better tracking of when data was last synchronised from
external sources, which is crucial for match scoring systems that may import results from external platforms
or devices.

Beyond schema improvements, this release marks the project's **transition to open source** with the adoption
of the MIT Licence, making it freely available for use, modification, and distribution by the broader shooting
sports community. The establishment of comprehensive documentation standards (CHANGELOG.md, HISTORY.md, and
versioned release notes) ensures long-term maintainability and transparency.

### 📋 Major Changes

- **Breaking**: Removed `club_name` from `ipsc_match` and `club` from `match_competitor` tables
- **New**: Added `date_refreshed` tracking columns to match and result tables
- **Improved**: Consolidated schema modification scripts with clear date markers
- **Enhanced**: Documentation templates for changelog and release notes
- **Licence**: Changed from proprietary "All Rights Reserved" to MIT Licence
- **Documentation**: Created CHANGELOG.md, HISTORY.md, and versioned release notes in `documentation/history/`

### ⚠️ Impact

This release requires **database migration** and **application code updates** for existing installations. All
queries that previously accessed `club_name` directly must be updated to use JOIN operations with the `club`
table.

The **MIT Licence adoption** makes this project freely available to the shooting sports community, enabling
clubs worldwide to use, modify, and contribute to the database schema. The comprehensive documentation
structure provides a solid foundation for future community contributions and version management.

### 🔗 Related Documentation

- [Full Release Notes](RELEASE_NOTES.md) – Complete details for version 2.0.0
- [Versioned Release Notes](documentation/history/RELEASE_NOTES_HISTORY.md) – Archived release notes in
  the history directory
- [Changelog Entry](CHANGELOG.md#-200---2026-02-23) – Categorised list of all changes
- [Migration Guide](RELEASE_NOTES.md#-upgrade-guide) - Step-by-step upgrade instructions
- [MIT Licence](LICENSE.md) - Open source licence details

---

## 🧭 Version 1.1.0 – Enhanced Schema & Documentation

**Released:** January 28, 2026  
**Type:** Minor Release (Feature Addition)

### ✨ Release Theme

This release focused on **schema maturity** and **comprehensive documentation**, establishing a solid
foundation for the HPSC Database with complete table definitions, foreign key constraints, and detailed
architectural documentation.

### 🎯 Key Objectives

1. **Complete Schema Definition**: Finalise all core domain tables with proper relationships
2. **Establish Foreign Keys**: Implement referential integrity constraints across all tables
3. **Document Architecture**: Create comprehensive technical documentation
4. **Provide Quick Start**: Enable developers to quickly understand and deploy the database

### 📖 Why This Release Matters

Version 1.1.0 transformed the initial prototype into a production-ready database schema. The addition of
comprehensive documentation (ARCHITECTURE.md) and enhanced README provided developers with the context and
guidance needed to understand the database design principles and deployment procedures.

This release established the pattern of "database-first" design with a normalised relational schema, setting
the architectural direction for future enhancements.

### 📋 Major Changes

- **New**: Complete table definitions in `table_create_v1.0.0.sql`
- **New**: Foreign key constraints for referential integrity
- **New**: Comprehensive architecture documentation
- **Improved**: Enhanced README with a quick start guide
- **Added**: Schema creation and seed data scripts

### ⚠️ Impact

This release provided the foundation for production deployment, with all necessary scripts and documentation
for setting up new database instances.

### 🔗 Related Documentation

- [Changelog Entry](CHANGELOG.md#-110---2026-01-28) – Complete list of additions and changes
- [Architecture Documentation](ARCHITECTURE.md) - Database design principles and technical requirements

---

## 🧭 Version 1.0.0 – Initial Release

**Released:** December 28, 2025  
**Type:** Major Release (Initial)

### ✨ Release Theme

The inaugural release of the HPSC Database, establishing the **foundational schema** for managing practical
shooting club data, including clubs, competitors, matches, stages, and results.

### 🎯 Key Objectives

1. **Define Core Entities**: Establish the primary database tables for clubs, competitors, and matches
2. **Support Results Tracking**: Create tables for recording match and stage-level performance data
3. **Enable Standings Logs**: Implement logging tables for derived competitor standings
4. **Initialise Project**: Set up repository structure and basic documentation

### 📖 Why This Release Matters

Version 1.0.0 launched the HPSC Database project, providing the first working schema for practical shooting
match management. This release established the core data model that supports typical shooting club workflows:
registering clubs and competitors, creating matches with stages, recording participation, and tracking
stage-by-stage scoring.

The initial schema design prioritised flexibility and extensibility, with support for multiple divisions,
disciplines, power factors, and categories—all essential for IPSC-style shooting competitions.

### 📋 Major Changes

- **New**: Core domain tables (club, competitor, match, match_stage)
- **New**: Result tracking tables (match_competitor, match_stage_competitor)
- **New**: Logging tables for derived standings (log_match, log_matches)
- **New**: Basic schema creation scripts
- **New**: Initial project documentation and licence

### ⚠️ Impact

This release provided the initial working database schema for the Hartbeespoortdam Practical Shooting Club,
enabling the club to begin tracking match results and competitor performance digitally.

### 🔗 Related Documentation

- [Changelog Entry](CHANGELOG.md#-100---2025-12-28) – Initial release details
- [README](README.md) – Project introduction and overview

---

## 🧭 Release Versioning Strategy

The HPSC Database project follows [Semantic Versioning](https://semver.org/) (SemVer):

- **Major versions (X.0.0)**: Breaking changes, significant schema modifications requiring migration
- **Minor versions (0.X.0)**: New features, backward-compatible additions
- **Patch versions (0.0.X)**: Bug fixes, documentation updates, backward-compatible fixes

### 🧩 Version Types

- **Feature Release**: Introduces new features or enhancements (e.g. 1.1.0)
- **Breaking Change**: Involves changes that require migration or may affect existing functionality
  (e.g. 2.0.0)
- **Patch Release**: Contains bug fixes or minor improvements (e.g. 2.0.1)

### 🗺️ Version History Timeline

```
v1.0.0 (2025-12-28) ─── Initial Release
   │
   └─> v1.1.0 (2026-01-28) ─── Schema Maturity
          │
          └─> v2.0.0 (2026-02-23) ─── Breaking Changes
                 │
                 └─> v2.0.1 (2026-02-25) ─── Documentation & Release Hygiene
                        │
                        └─> v3.0.0 (2026-03-13) ─── Migration Reliability
```

---

## 🚀 Looking Forward

### 🛠️ Upcoming Enhancements

Future releases will focus on:

- **Query Optimization**: Views for leaderboards and competitor history
- **Automation**: Stored procedures for computing match aggregates
- **Developer Tools**: Additional seed data and demo scripts
- **Performance**: Indexing strategies for common query patterns

### 🔭 Long-term Vision

The HPSC Database aims to become a comprehensive, production-ready, **open source** database solution for
practical shooting clubs worldwide, supporting:

- Multi-club management and series tracking
- Historical performance analytics
- Integration with scoring devices and platforms
- Flexible reporting and leaderboard generation
- **Community contributions** and collaborative improvements under the MIT Licence

---

## 🔗 Additional Resources

- [Changelog](CHANGELOG.md) – Detailed, categorised list of changes for each version following Keep a
  Changelog format
- [Release Notes](RELEASE_NOTES.md) – Comprehensive release information for version 3.0.0 with upgrade guides
  and breaking changes
- [Architecture Documentation](ARCHITECTURE.md) - Detailed database architecture, design principles, and
  technical requirements
- [Project Overview & Quick Start Guide](README.md) – Introduction to the HPSC Database with schema entities,
  conventions, and typical workflows
- [Improvement Suggestions](documentation/roadmap/SUGGESTIONS.md) - Future enhancements, indexing strategies,
  and change management best practices
- [MIT Licence](LICENSE.md) - Open source licence terms and conditions

---

## 💬 Questions or Feedback?

For questions about release history, version strategy, or to provide feedback:

- **Maintainer**: Leoni Lubbinge
- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---

*Last Updated: 2026-03-13*


