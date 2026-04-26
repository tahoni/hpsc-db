# Release Notes

## Version 3.1.0

**Release Date:** March 15, 2026
**Branch:** develop → main

---

## 📌 Overview

This release standardises SQL script version naming and improves operational match-data maintenance.
It introduces a dedicated v3.0.0 delete workflow for `ipsc_match` data and aligns release documentation
with the renamed v1.1.0 baseline scripts.

---

## ✨ What's New

### 🧰 SQL Script Additions

- **New script**: Added `scripts/table_delete-ipsc_match-v3.0.0.sql` for transactional, foreign-key-safe
  deletion of `ipsc_match` and dependent match-result data.

### 📝 Script Reference Alignment

- **Versioned script naming**: Renamed `scripts/table_create_v1.0.0.sql` to
  `scripts/table_create-v1.1.0.sql`
- **Versioned seed script naming**: Renamed `scripts/table_data.sql` to
  `scripts/table_data-v1.1.0.sql`

---

## 🐛 Bug Fixes

- Fixed outdated script-name references in release documentation and historical changelog entries.

---

## 🚀 Improvements

### ⚙️ Documentation and Maintenance Reliability

- Documentation and changelog references now consistently target `v1.1.0` script filenames.
- Added a repeatable match-data clean-up script for v3.0.0 operational reset workflows.

---

## 🔧 Technical Details

### Database Changes

- `scripts/table_delete-ipsc_match-v3.0.0.sql`
    - Deletes `match_stage_competitor` rows linked to `ipsc_match`
    - Deletes `match_competitor` rows linked to `ipsc_match`
    - Deletes `ipsc_match_stage` rows linked to `ipsc_match`
    - Deletes `ipsc_match` rows within a single transaction (`START TRANSACTION` / `COMMIT`)
- `scripts/table_alter-v2.0.0.sql`
    - Updated script reference comment to `table_create-v1.1.0.sql`
- Historical documentation updates
    - Updated script names in `CHANGELOG.md`, `HISTORY.md`,
      `documentation/history/RELEASE_NOTES_v1.1.0.md`, and
      `documentation/history/RELEASE_NOTES_v2.0.0.md`

---

## 📦 Upgrade Guide

### For New Installations

- Apply `scripts/table_create-v1.1.0.sql` for base schema creation.
- Apply subsequent migration scripts (including v2.0.0 and v3.1.0 changes) as required.

### For Existing Installations

1. Back up your database.
2. Update local automation/scripts to use:
    - `scripts/table_create-v1.1.0.sql`
    - `scripts/table_data-v1.1.0.sql`
3. Use `scripts/table_delete-ipsc_match-v3.0.0.sql` when a full match-data reset is required.

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

**Leoni Lubbinge** – SQL script maintenance and release documentation updates

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
