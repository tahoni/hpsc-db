# Release Notes

## Version 4.0.0

**Release Date:** May 31, 2026
**Branch:** release/version-4.0.0 → main

---

## 📌 Overview

This release introduces comprehensive enhancements to the competitor schema with extended contact and identification information and provides a complete freshly versioned schema creation script for v4.0.0. It includes an extensive seed data migration with 200+ competitor records containing full contact details and SAPSA membership information.

---

## ✨ What's New

### 🧰 SQL Script Additions

- **New script**: Added `scripts/table_create-v4.0.0.sql` to provide a comprehensive, freshly versioned schema creation script for v4.0.0 implementations
- **New script**: Added `scripts/table_alter-v4.0.0.sql` for schema migrations to v4.0.0, extending the competitor table with additional contact and identification fields
- **New script**: Added `scripts/table_data-v4.0.0.sql` with comprehensive seed data containing 200+ competitor records with full contact details and membership information

### 🧰 Schema Enhancements

The competitor table has been extended with the following new fields:

- **`nickname`** – Optional nickname/short name for the competitor
- **`gender`** – Competitor gender classification (VARCHAR(36) for flexibility)
- **`club_number`** – Club-specific competitor number (unique constraint: `uk_competitor_club_number`)
- **`id_number`** – National identity/passport number for verification
- **`cellphone_number`** – Primary mobile phone contact
- **`email_address`** – Primary email address for communication
- **`secondary_email_address`** – Secondary email address for notifications

### 📊 Seed Data Enhancements

- **Comprehensive competitor roster**: `table_data-v4.0.0.sql` includes 200+ competitor records pre-populated with:
  - Full names (first, middle, last) and nicknames
  - SAPSA membership numbers for national federation tracking
  - Club-specific competitor and club numbers
  - Contact information (cellphone, email)
  - Identity verification numbers
  - Gender classifications

### 🔧 Schema Versioning

- **Fresh v4.0.0 schema**: `table_create-v4.0.0.sql` provides a complete standalone schema creation script at the v4.0.0 level, enabling direct deployments without needing to apply sequential migration scripts

---

## 🐛 Bug Fixes

- Fixed `table_alter-v3.2.0.sql` formatting by adding clear date markers and descriptive comments for improved maintainability

---

## 🚀 Improvements

### 📝 Enhanced Competitor Information Management

- Competitor profiles now include comprehensive contact and identification information, supporting:
  - Multichannel communication (cellphone, email, secondary email)
  - Identity verification and compliance
  - Gender-aware competitor management
  - Club-specific competitor numbering systems

### 🧭 Simplified New Installations

- `table_create-v4.0.0.sql` provides a single, unified schema creation script, eliminating the need to apply multiple historical migration scripts for new v4.0.0 deployments
- New installations can adopt v4.0.0 directly without managing backward-compatibility layers

### 🌍 Expanded Competitor Coverage

- Preloaded competitor seed data covers a broad South African practical shooting community (200+ competitors)
- Data includes verified SAPSA membership information for federation compliance

### ⚙️ SQL Script Clarity

- Enhanced comments and date markers in migration scripts improve clarity and maintainability
- All v4.0.0 scripts dated 2026-05-31 for easy version tracking

---

## 🔧 Technical Details

### Database Changes

- **`competitor` table extensions** (via `table_alter-v4.0.0.sql`):
  - Added 7 new columns: `nickname`, `gender`, `club_number`, `id_number`, `cellphone_number`, `email_address`, `secondary_email_address`
  - Added new unique constraint: `uk_competitor_club_number` on the `club_number` column
  - Existing `uk_competitor_sapsa_number` constraint retained and enforced

- **Full v4.0.0 schema** (`table_create-v4.0.0.sql`):
  - Includes all tables from previous versions with cumulative enhancements
  - Pre-configured indexes for optimal query performance:
    - `idx_ipsc_match_club_id`, `idx_ipsc_match_stage_match_id`
    - `idx_match_competitor_competitor_id`, `idx_match_competitor_match_id`
    - `idx_match_stage_competitor_competitor_id`, `idx_match_stage_competitor_match_stage_id`

### Seed Data

- **`table_data-v4.0.0.sql`** (243 lines, 200+ competitor records):
  - Includes verified club numbers, SAPSA membership IDs and contact information
  - Supports multiple competitors per club with proper club-number uniqueness
  - Enables immediate competitive operations without additional data entry

---

## 📦 Upgrade Guide

### For New Installations (v4.0.0)

1. Execute `scripts/table_create-v4.0.0.sql` for complete schema creation.
2. (Optional) Execute `scripts/table_data-v4.0.0.sql` for comprehensive competitor seed data.
3. Begin operational use.

### For Existing Installations (v3.2.0 → v4.0.0)

1. Back up your database.
2. Execute `scripts/table_alter-v4.0.0.sql` to extend the competitor schema:
    ```sql
    SOURCE scripts/table_alter-v4.0.0.sql;
    ```
3. (Optional) Merge competitor data from `scripts/table_data-v4.0.0.sql`:
    - Review the seed data to avoid duplicate SAPSA numbers or club numbers
    - Insert only new competitor records relevant to your environment

### Version Migration Path

- v1.0.0 → v1.1.0 → v2.0.0 → v2.0.1 → v3.0.0 → v3.1.0 → v3.2.0 → **v4.0.0**

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

- [Architecture Documentation](/ARCHITECTURE.md) – Detailed database architecture and design principles
- [Project Overview & Quick Start Guide](/README.md) – Introduction to the HPSC Database and setup workflow
- [Release Notes History](/documentation/history/RELEASE_NOTES_HISTORY.md) – Versioned release notes index

---

## 💬 Feedback

For questions, issues or suggestions, please contact:

- **Email**: leonil@tahoni.info
- **GitHub**: [@tahoni](https://github.com/tahoni)

---

**Full Changelog**: main vs release/version-4.0.0 - `git log main..release/version-4.0.0`
