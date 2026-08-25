# 🗄️ HPSC Database

The official repository for the Hartbeespoortdam Practical Shooting Club (HPSC) database schema.

## 📌 Table of contents

- [📖 Introduction](#-introduction)
- [🧩 Schema Entities](#-schema-entities)
    - [🧱 Core Entities](#-core-entities)
    - [🏁 Results](#-results)
    - [📊 Logging / Derived Standings (planned)](#-logging--derived-standings-planned)
- [🧭 Quick Start (DataGrip)](#-quick-start-datagrip)
- [📏 Conventions and Constraints](#-conventions-and-constraints)
    - [🔗 Foreign Keys](#-foreign-keys)
    - [✅ Uniqueness Constraints](#-uniqueness-constraints)
- [✅ Typical Workflows Supported](#-typical-workflows-supported)
    - [🧭 Common Workflow Steps](#-common-workflow-steps)
- [🧭 Version Information](#-version-information)
    - [✨ Key v4.1.0 Improvements](#-key-v410-improvements)
- [⚠️ Breaking Changes in v4.1.0](#-breaking-changes-in-v410)
- [⚠️ Breaking Changes in v2.0.0](#-breaking-changes-in-v200)
- [🏗️ Architecture](#-architecture)
- [📜 Licence](#-licence)
- [🔗 Additional Resources](#-additional-resources)
- [👤 Author](#-author)

## 📖 Introduction

This repository contains a relational database schema for managing shooting match results:
clubs, competitors, matches, stages, per-match competitor performance, and per-stage scores.
It is also designed to support logging tables for derived/aggregated competitor standings across matches
(see [📊 Logging / Derived Standings (planned)](#-logging--derived-standings-planned)).

## 🧩 Schema Entities

### 🧱 Core Entities

- **Club**: organizing entity (name, abbreviation).
- **Competitor**: person identity and identifiers — name, optional nickname, date of birth, gender
  (`Male`/`Female`), an optional SAPSA number, an optional competitor number, a unique club number, and
  optional contact details (ID number, cellphone, email address).
- **Match**: a scheduled match hosted by a club (name/date and optional division/category).
- **Match stage**: stages within a match (stage number, optional range number).

### 🏁 Results

- **Match competitor**: a competitor’s participation in a specific match, including
  division/discipline/power factor and overall match points/percentage.
- **Match stage competitor**: stage-level performance for a match competitor (points, penalties,
  time, hit factor, stage points/percentage).

### 📊 Logging / Derived Standings (planned)

> Not yet implemented — tracked in the [🧪 Unreleased](CHANGELOG.md#-unreleased) section of `CHANGELOG.md`.
> See [ARCHITECTURE.md](ARCHITECTURE.md#-logging-and-summary-tables-planned) for details.

- **Log match**: per-competitor results for a single match (place, points, percentage).
- **Log matches**: per-competitor results across a match range/window (min/max match IDs and
  place/points/percentage).

## 🧭 Quick Start (DataGrip)

1. Create or select a database/schema (e.g. MySQL-compatible).
2. Open the SQL migration/schema file(s) in DataGrip.
3. Run the script against your target database.
4. Verify tables and relationships in the **Database Explorer** diagram view (helps confirm foreign keys and
   uniqueness constraints).

## 📏 Conventions and Constraints

### 🔗 Foreign Keys

- Foreign keys enforce referential integrity between:
    - match → club
    - match_stage → match
    - match_competitor → match, competitor
    - match_stage_competitor → match_stage, match_competitor
    - log tables *(planned)* → competitor, match (and match ranges)

### ✅ Uniqueness Constraints

- Uniqueness constraints prevent duplicates such as:
    - duplicate club names/abbreviations
    - duplicate competitor identity composites / identifiers
    - duplicate match identity within a club by (club, name, scheduled_date)
    - duplicate competitor enrollment per match
    - duplicate stage result rows per (stage, competitor-in-match)

## ✅ Typical Workflows Supported

### 🧭 Common Workflow Steps

- Register clubs and competitors.
- Create matches and stages for a scheduled event.
- Record competitors participating in a match (division/discipline/power factor).
- Record stage-by-stage scoring and compute stage/match aggregates (or store them when computed elsewhere).
- Store leaderboard snapshots in log tables (single match or match window) — *planned, not yet
  implemented*.

## 🧭 Version Information

**Current Version:** 4.1.0 (Released May 31, 2026)

This minor release refines the schema introduced in v4.0.0, relaxing overly strict `competitor` constraints,
removing unused columns, and standardising `date_created`/`date_updated` handling across every table. For
detailed version history and upgrade information, see [HISTORY.md](HISTORY.md)
and [RELEASE_NOTES.md](RELEASE_NOTES.md).

### ✨ Key v4.1.0 Improvements

- **Relaxed Constraints**: `competitor.competitor_number` is now nullable and the `uk_competitor_sapsa_number`
  uniqueness requirement has been removed to match real club data
- **Constrained Gender Values**: `competitor.gender` is now an `ENUM('Male', 'Female')` instead of free text
- **Reduced Schema Surface**: Removed the unused `secondary_email_address` column and the superseded
  `date_edited`/`date_refreshed` columns
- **Automatic Timestamps**: `date_created`/`date_updated` are now managed automatically by the database on
  every table

## ⚠️ Breaking Changes in v4.1.0

⚠️ **Schema Changes:**

The following changes require attention when upgrading from v4.0.0:

- `competitor.secondary_email_address` – Column removed. Back up this data before upgrading if it is still
  required.
- `competitor.gender` – Changed from free-text `VARCHAR(36)` to `ENUM('Male', 'Female')`. Existing rows with
  values outside those two must be cleaned up before migrating.
- `uk_competitor_sapsa_number` – Unique constraint removed from `competitor.sapsa_number`. Applications can
  no longer rely on the database to enforce SAPSA number uniqueness.
- `ipsc_match.date_edited`, `ipsc_match.date_refreshed`, `match_competitor.date_edited`,
  `match_stage_competitor.date_edited` – Columns removed. Use `date_updated` instead, which is now
  populated and refreshed automatically by the database.

**Update Required:** Clean up non-conforming `gender` values and stop relying on `date_edited`/
`date_refreshed` before applying the migration:

```sql
-- Before migrating, normalise any gender values outside the new ENUM:
UPDATE competitor
SET gender = NULL
WHERE gender NOT IN ('Male', 'Female');

-- Old approach (no longer supported):
SELECT id, name, date_edited, date_refreshed
FROM ipsc_match;

-- New approach:
SELECT id, name, date_updated
FROM ipsc_match;
```

For complete upgrade instructions, see [RELEASE_NOTES.md](RELEASE_NOTES.md#-upgrade-guide).

## ⚠️ Breaking Changes in v2.0.0

⚠️ **Schema Changes:**

The following columns have been removed to enforce database normalisation:

- `ipsc_match.club_name` – Use JOIN with `club` table instead
- `match_competitor.club` – Retrieve via `match_id` → `club_id` relationship

**Update Required:** Applications must use proper JOIN operations to retrieve club information:

```sql
-- Old approach (no longer supported):
SELECT m.name, m.club_name
FROM ipsc_match m;

-- New approach:
SELECT m.name, c.name AS club_name, c.abbreviation
FROM ipsc_match m
         JOIN club c ON m.club_id = c.id;
```

For complete upgrade instructions, see [RELEASE_NOTES.md](RELEASE_NOTES.md#-upgrade-guide).

## 🏗️ Architecture

A detailed explanation of the architecture can be found in the [`ARCHITECTURE.md`](ARCHITECTURE.md) file.

## 📜 Licence

The copyright licence can be found in the [`LICENSE.md`](LICENSE.md) file.

## 🔗 Additional Resources

- [Architecture Documentation](ARCHITECTURE.md) - Detailed database architecture, design principles, and
  technical requirements
- [Release Notes](RELEASE_NOTES.md) – Comprehensive information for version 4.1.0 including upgrade guides and
  breaking changes
- [Release History](HISTORY.md) – Historical overview of all releases with version themes and objectives
- [Changelog](CHANGELOG.md) – Categorised list of all changes for each version
- [Improvement Suggestions](documentation/roadmap/SUGGESTIONS.md) – Future enhancements and change management
  best practices

## 👤 Author

**Leoni Lubbinge**

- [![Website Badge](https://custom-icon-badges.demolab.com/badge/https%3A%2F%2Ftahoni.info-blue?logo=file-code)](https://www.tahoni.info)
- [![Email Badge](https://custom-icon-badges.demolab.com/badge/leonil%40tahoni.info-blue?logo=mail)](mailto:leonil@tahoni.info)


- [![Gmail Badge](https://img.shields.io/badge/tahoni%40gmail.com-blue?logo=gmail)](mailto:tahoni@gmail.com)
- [![GitHub Badge](https://img.shields.io/badge/Leoni_Lubbinge-blue?logo=github)](https://github.com/tahoni)
- [![LinkedIn Badge](https://custom-icon-badges.demolab.com/badge/Leoni_Lubbinge-blue.svg?logoSource=feather&logo=linkedin)](https://www.linkedin.com/in/leoni-lubbinge-06066b16/)




