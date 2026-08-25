# Release Notes

## Version 4.1.0

**Release Date:** May 31, 2026
**Branch:** feature/version-4.1.0 → main

---

## 📌 Overview

This release refines the schema introduced in v4.0.0 based on real-world data from the v4.0.0 seed import. It
relaxes overly strict constraints, removes columns that proved unnecessary or unused, and standardises
timestamp handling across every table so that `date_created` and `date_updated` are populated automatically
by the database instead of relying on application code.

---

## ✨ What's New

### 🧰 SQL Script Additions

- **New script**: Added `scripts/table_create-v4.1.0.sql` — a unified schema creation script covering the
  `club`, `competitor`, `ipsc_match`, `ipsc_match_stage`, `match_competitor` and `match_stage_competitor`
  tables and their associations
- **New script**: Added `scripts/table_alter-v4.1.0.sql` for migrating existing v4.0.0 installations to
  v4.1.0
- **New script**: Added `scripts/table_data-v4.1.0.sql` with the comprehensive competitor seed data
  refreshed to match the v4.1.0 schema

### 🧰 Schema Refinements

- **`competitor.gender`** — changed from a free-text `VARCHAR(36)` to a constrained `ENUM('Male', 'Female')`,
  remaining nullable
- **`competitor.competitor_number`** — relaxed from `NOT NULL` to nullable, reflecting that this value is not
  always available at competitor creation time
- **`competitor.secondary_email_address`** — column removed; it was unused in practice
- **`uk_competitor_sapsa_number`** — unique constraint removed from `competitor.sapsa_number`, since not
  every competitor record has a unique (or populated) SAPSA number
- **`ipsc_match.date_edited`** and **`ipsc_match.date_refreshed`** — columns removed, superseded by the
  auto-managed `date_updated` column
- **`match_competitor.date_edited`** and **`match_stage_competitor.date_edited`** — columns removed for the
  same reason

### ⏱️ Automatic Timestamp Management

- `date_created` now defaults to `CURRENT_TIMESTAMP` and `date_updated` now updates automatically via
  `ON UPDATE CURRENT_TIMESTAMP` on `club`, `competitor`, `ipsc_match`, `ipsc_match_stage`,
  `match_competitor` and `match_stage_competitor` — these columns previously had no default and had to be
  set manually

### 📊 Seed Data Refresh

- `table_data-v4.1.0.sql` realigns the 200+ competitor seed records with the updated schema, using `NULL`
  instead of empty strings for unknown `gender` values so the data is valid against the new `ENUM` column

---

## 🐛 Bug Fixes

- None reported in this release.

---

## 🚀 Improvements

### 🧭 Simplified New Installations

- `table_create-v4.1.0.sql` provides a single, unified schema creation script for new v4.1.0 deployments

### ⚙️ Data Integrity Aligned with Real-World Usage

- Removing the `uk_competitor_sapsa_number` constraint and relaxing `competitor_number` to nullable avoids
  insert failures against real club data where these values are frequently missing or duplicated
- Constraining `gender` to an `ENUM` prevents inconsistent free-text values going forward

### 🧹 Reduced Schema Surface

- Dropping the unused `secondary_email_address`, `date_edited` and `date_refreshed` columns simplifies the
  schema and removes columns never populated by application code

---

## 🔧 Technical Details

### Database Changes

- **`competitor` table** (via `table_alter-v4.1.0.sql`):
  - `gender` changed to `ENUM('Male', 'Female')`, remains nullable
  - `competitor_number` changed to nullable
  - `secondary_email_address` column dropped
  - `uk_competitor_sapsa_number` unique constraint dropped
  - `date_created` / `date_updated` given `DEFAULT CURRENT_TIMESTAMP` / `ON UPDATE CURRENT_TIMESTAMP`
- **`club` table**: `date_created` / `date_updated` given `DEFAULT CURRENT_TIMESTAMP` /
  `ON UPDATE CURRENT_TIMESTAMP`
- **`ipsc_match` table**: `date_edited` and `date_refreshed` columns dropped; `date_created` / `date_updated`
  given `DEFAULT CURRENT_TIMESTAMP` / `ON UPDATE CURRENT_TIMESTAMP`
- **`ipsc_match_stage` table**: `date_created` / `date_updated` given `DEFAULT CURRENT_TIMESTAMP` /
  `ON UPDATE CURRENT_TIMESTAMP`
- **`match_competitor` table**: `date_edited` column dropped; `date_created` / `date_updated` given
  `DEFAULT CURRENT_TIMESTAMP` / `ON UPDATE CURRENT_TIMESTAMP`
- **`match_stage_competitor` table**: `date_edited` column dropped; `date_created` / `date_updated` given
  `DEFAULT CURRENT_TIMESTAMP` / `ON UPDATE CURRENT_TIMESTAMP`

### Seed Data

- **`table_data-v4.1.0.sql`** (240 lines, 200+ competitor records): same competitor roster as v4.0.0,
  refreshed to use `NULL` rather than empty strings for unpopulated `gender` values

---

## 📦 Upgrade Guide

### For New Installations (v4.1.0)

1. Execute `scripts/table_create-v4.1.0.sql` for complete schema creation.
2. (Optional) Execute `scripts/table_data-v4.1.0.sql` for comprehensive competitor seed data.
3. Begin operational use.

### For Existing Installations (v4.0.0 → v4.1.0)

1. Back up your database.
2. Execute `scripts/table_alter-v4.1.0.sql` to apply the schema refinements:
    ```sql
    SOURCE scripts/table_alter-v4.1.0.sql;
    ```
3. Review any existing `competitor.gender` values — free-text values outside `'Male'` / `'Female'` must be
   cleaned up before (or as part of) the migration, since the column becomes an `ENUM`.
4. Note that `competitor.secondary_email_address` data will be lost when the column is dropped — export it
   first if it needs to be retained elsewhere.

### Version Migration Path

- v1.0.0 → v1.1.0 → v2.0.0 → v2.0.1 → v3.0.0 → v3.1.0 → v3.2.0 → v4.0.0 → **v4.1.0**

---

## ⚠️ Breaking Changes

- **`competitor.secondary_email_address`** has been removed. Back up this data before upgrading if it is
  still required.
- **`competitor.gender`** is now an `ENUM('Male', 'Female')`. Existing rows with other free-text values will
  fail to migrate until cleaned up.
- **`uk_competitor_sapsa_number`** unique constraint has been removed. Application logic that relied on the
  database to enforce SAPSA number uniqueness must now perform that check itself.
- **`ipsc_match.date_edited`**, **`ipsc_match.date_refreshed`**, **`match_competitor.date_edited`** and
  **`match_stage_competitor.date_edited`** have been removed. Use `date_updated` instead.

---

## ℹ️ Known Issues

None reported at this time.

---

## 📢 Deprecations

None introduced in this release.

---

## 👥 Contributors

**Leoni Lubbinge** – Schema refinements, timestamp standardisation, migration script addition and seed data
refresh

---

## 🔗 Additional Resources

- [Architecture Documentation](/ARCHITECTURE.md) – Detailed database architecture and design principles
- [Project Overview & Quick Start Guide](/README.md) – Introduction to the HPSC Database and setup workflow
- [Release Notes History](/documentation/history/RELEASE_NOTES_HISTORY.md) – Versioned release notes index

---

## 💬 Feedback

For questions, issues or suggestions, please contact:

- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---

**Full Changelog**: main vs feature/version-4.1.0 - `git log main..feature/version-4.1.0`
