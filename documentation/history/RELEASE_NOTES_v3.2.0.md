# Release Notes

## Version 3.2.0

**Release Date:** April 26, 2026
**Branch:** develop → main

---

## 📌 Overview

This release standardises SQL script file naming by replacing underscores with hyphens in version
suffixes for consistency across all scripts. The match-data deletion workflow is extended to include
competitor data, a forward-looking migration script for schema v4.0.0 is added, and all documentation
references are updated to reflect the renamed scripts.

---

## ✨ What's New

### 🧰 SQL Script Additions

- **New script**: Added `scripts/table_alter-v4..0.0.sql` to add a `UNIQUE` constraint on
  `competitor.sapsa_number` for the schema v4.0.0 migration.

### 📝 SQL Script Renames

All version-suffixed scripts have been renamed from underscore to hyphen convention:

- `scripts/table_create_v1.1.0.sql` → `scripts/table_create-v1.1.0.sql`
- `scripts/table_create_v3.0.0.sql` → `scripts/table_create-v3.0.0.sql`
- `scripts/table_data_v1.1.0.sql` → `scripts/table_data-v1.1.0.sql`
- `scripts/table_delete_ipsc_match_v3.0.0.sql` → `scripts/table_delete-ipsc_match-v3.0.0.sql`
- `scripts/table_drop_v3.0.0.sql` → `scripts/table_drop-v3.0.0.sql`

---

## 🐛 Bug Fixes

- Fixed outdated script-name references across all release documentation and historical changelog entries.

---

## 🚀 Improvements

### ⚙️ SQL Script Enhancements

- **Extended deletion scope**: `scripts/table_delete-ipsc_match-v3.0.0.sql` now also deletes all
  `competitor` rows, supporting full data clean-up beyond match data in operational reset workflows.

### 📝 Documentation and Maintenance Reliability

- All documentation references now consistently use hyphen-separated version suffixes in script filenames.
- Updated script-name references in `CHANGELOG.md`, `HISTORY.md`, `documentation/archive/ARCHIVE.md`,
  and all historical versioned release notes.

---

## 🔧 Technical Details

### Database Changes

- `scripts/table_delete-ipsc_match-v3.0.0.sql`
    - Added deletion of all `competitor` rows within the same transaction
- `scripts/table_alter-v4..0.0.sql` *(new)*
    - Adds `uk_competitor_sapsa_number` unique constraint on `competitor.sapsa_number`
- `scripts/table_alter-v2.0.0.sql`
    - Updated internal comment reference from `table_create_v1.1.0.sql` to `table_create-v1.1.0.sql`

### Script Renames

| Old Name                             | New Name                             |
|--------------------------------------|--------------------------------------|
| `table_create_v1.1.0.sql`            | `table_create-v1.1.0.sql`            |
| `table_create_v3.0.0.sql`            | `table_create-v3.0.0.sql`            |
| `table_data_v1.1.0.sql`              | `table_data-v1.1.0.sql`              |
| `table_delete_ipsc_match_v3.0.0.sql` | `table_delete-ipsc_match-v3.0.0.sql` |
| `table_drop_v3.0.0.sql`              | `table_drop-v3.0.0.sql`              |

---

## 📦 Upgrade Guide

### For New Installations

- Apply `scripts/table_create-v1.1.0.sql` for base schema creation.
- Apply subsequent migration scripts (v2.0.0, v3.0.0, and v3.1.0 changes) as required.

### For Existing Installations

1. Back up your database.
2. Update local automation and onboarding runbooks to use the renamed scripts:
    - `scripts/table_create-v1.1.0.sql`
    - `scripts/table_create-v3.0.0.sql`
    - `scripts/table_data-v1.1.0.sql`
    - `scripts/table_delete-ipsc_match-v3.0.0.sql`
    - `scripts/table_drop-v3.0.0.sql`
3. Note that `scripts/table_delete-ipsc_match-v3.0.0.sql` now also deletes all `competitor` rows —
   review any automation relying on this script for data scope changes.

---

## ⚠️ Breaking Changes

None introduced in this release.

---

## ℹ️ Known Issues

None reported at this time.

---

## 📢 Deprecations

None introduced in this release.

---

## 👥 Contributors

**Leoni Lubbinge** – SQL script renames, deletion script enhancement, migration script addition and
documentation updates

---

## 🔗 Additional Resources

- [Architecture Documentation](../../ARCHITECTURE.md) - Detailed database architecture and design principles
- [Project Overview & Quick Start Guide](../../README.md) – Introduction to the HPSC Database and setup
  workflow
- [Release Notes History](RELEASE_NOTES_HISTORY.md) – Versioned release notes index

---

## 💬 Feedback

For questions, issues, or suggestions, please contact:

- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---

**Full Changelog**: main vs develop - `git log main..develop`
