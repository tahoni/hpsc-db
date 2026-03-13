# Release Notes

## Version 3.0.0

**Release Date:** March 13, 2026
**Branch:** develop -> main

---

## 📌 Overview

This major release introduces schema-maintenance improvements for migration safety and operational resets.
It removes the legacy unique constraint on `ipsc_match.name` and adds dedicated drop-table scripts for
versioned schema teardown workflows.

---

## ✨ What's New

### 🗄️ Database Schema

- **Constraint update**: Removed the unique constraint/index on `ipsc_match.name`
- **Compatibility handling**: Uses metadata-driven SQL to resolve and drop the actual unique index name
  safely during migration

### 🧰 SQL Script Additions

- **New script**: Added `scripts/table_drop_v3.0.0.sql` for foreign-key-safe teardown of v3.0.0 tables
- **Backfill support**: Added `scripts/table_drop_v3.0.0.sql` for complete teardown of legacy v1.0.0 tables

---

## 🐛 Bug Fixes

- Fixed schema migration friction where environments used different unique index names for
  `ipsc_match.name`

---

## 🚀 Improvements

### ⚙️ Migration Reliability

- Dynamic index-name resolution avoids hardcoded index assumptions during upgrade
- `DROP TABLE IF EXISTS` patterns support repeatable local reset workflows

---

## 🔧 Technical Details

### Database Changes

- v3.0.0 migration update
    - Drops the unique index/constraint on `ipsc_match.name` when present
- `scripts/table_drop_v3.0.0.sql`
    - Adds FK-safe drop order for current schema tables
- `scripts/table_drop_v3.0.0.sql`
    - Adds FK-safe drop order for v1.0.0 schema tables

---

## 📦 Upgrade Guide

### For New Installations

- Apply `scripts/table_create_v3.0.0.sql`
- Use the v3.0.0 migration step when upgrading from schemas that still enforce uniqueness on
  `ipsc_match.name`

### For Existing Installations

1. Back up your database.
2. Apply the v3.0.0 migration that removes uniqueness from `ipsc_match.name`.
3. Validate that duplicates on `ipsc_match.name` are now allowed where required by business workflow.

---

## ⚠️ Breaking Changes

- **Behavioral change**: `ipsc_match.name` is no longer globally unique.
- Any application logic that relied on global uniqueness of match names must be updated to use additional
  qualifiers (for example, club and scheduled date).

---

## ℹ️ Known Issues

None reported at this time.

---

## 📢 Deprecations

None introduced in this release.

---

## 👥 Contributors

**Leoni Lubbinge** - Schema maintenance and release management

---

## 🔗 Additional Resources

- [Architecture Documentation](../../ARCHITECTURE.md) - Detailed database architecture and design principles
- [Project Overview & Quick Start Guide](../../README.md) - Introduction to the HPSC Database and setup
  workflow
- [Release Notes History](RELEASE_NOTES_HISTORY.md) - Versioned release notes index

---

## 💬 Feedback

For questions, issues, or suggestions, please contact:

- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---

**Full Changelog**: main vs develop - `git log main..develop`

