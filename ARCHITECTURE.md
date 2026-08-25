# 🏗️ HPSC Database Architecture

This document describes the architectural design, directory structure, and core concepts
of the database used by the Hartbeespoortdam Practical Shooting Club (HPSC) website.

## 📌 Table of Contents

- [📖 Introduction](#-introduction)
- [🗄️ Target Database](#-target-database)
    - [🛠️ Technical Requirements](#-technical-requirements)
    - [🧠 Design Considerations](#-design-considerations)
    - [❓ Why MySQL / InnoDB](#-why-mysql--innodb)
- [🗂️ Project Structure](#-project-structure)
- [🎯 Goals](#-goals)
- [🧱 Data Model Overview](#-data-model-overview)
    - [🧩 Core Domain Tables](#-core-domain-tables)
    - [🎯 Participation and Scoring Tables](#-participation-and-scoring-tables)
    - [🗃️ Logging and Summary Tables (planned)](#-logging-and-summary-tables-planned)
- [🔗 Key Relationships (conceptual)](#-key-relationships-conceptual)
- [🔐 Integrity Strategy](#-integrity-strategy)
- [🧮 Aggregation Strategy](#-aggregation-strategy)
- [⏱️ Temporal Tracking & Data Synchronisation](#-temporal-tracking--data-synchronisation)
    - [🎯 Purpose](#-purpose)
    - [🧪 Usage](#-usage)
- [⚠️ Normalisation & Breaking Changes](#-normalisation--breaking-changes)
    - [🧭 Version 2.0.0 Breaking Changes](#-version-200-breaking-changes)
    - [🗑️ Removed Denormalised Columns](#-removed-denormalised-columns)
    - [📌 Rationale](#-rationale)
    - [🛣️ Migration Path](#-migration-path)
- [🚀 Schema Enhancements](#-schema-enhancements)
    - [✨ Version 4.0.0 Competitor Enhancements](#-version-400-competitor-enhancements)
    - [✨ Version 4.1.0 Schema Refinements](#-version-410-schema-refinements)
- [💡 Design Philosophy](#-design-philosophy)

## 📖 Introduction

This project is a **database-first** design centered on a normalised relational schema for shooting match
results and derived standings.

## 🗄️ Target Database

### 🛠️ Technical Requirements

- **Database engine**: **MySQL 8.x**
- **Storage engine**: **InnoDB**
- **Character set**: `utf8mb4`
- **Collation**: `utf8mb4_0900_ai_ci`

### 🧠 Design Considerations

- Collation: use a consistent collation across environments (e.g., `utf8mb4_0900_ai_ci`)
- Time zone: keep server/app time zone consistent; store match dates as `DATE` (already aligned)

### ❓ Why MySQL / InnoDB

- Foreign keys and transactional integrity for match → stage → results relationships
- Good support for indexing and uniqueness constraints used to prevent duplicate entries
- Operationally simple for local development and small deployments

## 🗂️ Project Structure

```text
├───documentation       # Project documentation and templates
└───scripts             # Database scripts, including baseline schema and change scripts.
```

## 🎯 Goals

- Represent matches, stages, competitors, and clubs with clear ownership.
- Prevent duplicates via foreign keys and uniqueness constraints.
- Support both **raw scoring data** (stage results) and **derived summaries** (match totals, logs).

## 🧱 Data Model Overview

### 🧩 Core Domain Tables

- **club**
    - Represents an organising club.
    - Unique identity is enforced (e.g. by name and abbreviation).

- **competitor**
    - Represents an athlete/person.
    - Stores identity fields and identifiers, including an optional SAPSA membership number and a
      club-specific competitor number.
    - As of version 4.0.0, it supports comprehensive contact information (cellphone, email) and demographic data
      (gender, nickname).
    - As of version 4.1.0, `gender` is constrained to `ENUM('Male', 'Female')`, `competitor_number` is
      optional, and `secondary_email_address` has been removed. See
      [✨ Version 4.1.0 Schema Refinements](#-version-410-schema-refinements).
    - Uniqueness is enforced on the club-specific competitor number (`uk_competitor_club_number`). As of
      version 4.1.0, SAPSA numbers are **no longer required to be unique** at the database level, since not
      every real competitor record has one populated.

- **match**
    - Represents a scheduled event hosted by a club.
    - Tied to a club via a foreign key.
    - Uniqueness is enforced per club and date/name to avoid duplicate matches.

- **match_stage**
    - Represents a stage within a match.
    - Stage numbering is unique per match.

### 🎯 Participation and Scoring Tables

- **match_competitor**
    - A join table between match and competitor (a competitor’s participation in a match).
    - Stores match-level attributes (division/discipline/power factor).
    - Stores match-level results (points, percentage) if computed externally or as a persisted aggregate.

- **match_stage_competitor**
    - Associates a competitor-in-match with a match stage.
    - Stores stage metrics (points, penalties, time, hit factor) and optional persisted aggregates
      (stage points/percentage).

### 🗃️ Logging and Summary Tables (planned)

> ℹ️ **Not yet implemented.** These tables are part of the target design but have not been created by any
> schema script as of v4.1.0. Their addition — along with the stored procedures that would populate them —
> is tracked in the [🧪 Unreleased](CHANGELOG.md#-unreleased) section of `CHANGELOG.md`.

- **log_match**
    - Snapshot/summary of competitor performance for a single match (place, points, percentage).
    - Useful for quick leaderboard access without recomputation.

- **log_matches**
    - Snapshot/summary across a window of matches (min_match_id → max_match_id).
    - Useful for series scoring, season windows, or rolling comparisons.

## 🔗 Key Relationships (conceptual)

- club 1 → N match
- match 1 → N match_stage
- competitor N ↔ N match (via match_competitor)
- match_stage 1 → N match_stage_competitor
- match_competitor 1 → N match_stage_competitor

The planned logging tables would reference competitor and match (or match ranges) to maintain provenance
(see [🗃️ Logging and Summary Tables (planned)](#-logging-and-summary-tables-planned)).

## 🔐 Integrity Strategy

- **Primary keys**: surrogate integer IDs for stable references.
- **Foreign keys**: enforce that dependent rows cannot exist without parents.
    - In MySQL, foreign keys require InnoDB.
- **Unique constraints**: prevent duplicates in natural-key-like scenarios:
    - competitor enrollment per match
    - stage numbering per match
    - stage result uniqueness per (stage, competitor-in-match)
    - match uniqueness per (club, name, scheduled_date)

## 🧮 Aggregation Strategy

There are two common patterns this schema supports:

1. **Compute-on-read**
    - Stage rows are the source of truth.
    - Match totals and leaderboards are computed with SQL queries/views.

2. **Compute-and-store (snapshots / de-normalised aggregates)**
    - Persist match totals in `match_competitor`.
    - Persist stage totals in `match_stage_competitor` (where applicable).
    - Persist leaderboard snapshots in `log_match` and `log_matches` *(planned — not yet implemented, see
      [🗃️ Logging and Summary Tables (planned)](#-logging-and-summary-tables-planned))*.

Which approach you choose depends on scale, performance needs, and whether you want immutable historical
snapshots.

The approach used in this project is **compute-and-store**: match and stage totals are already persisted
directly on `match_competitor` and `match_stage_competitor`, while the leaderboard-snapshot logging tables
remain on the roadmap.

## ⏱️ Temporal Tracking & Data Synchronisation

> ⚠️ **Superseded in v4.1.0.** The manual `date_refreshed`/`date_edited` tracking described below was
> removed in version 4.1.0 in favour of database-managed timestamps. This section is kept for historical
> context; see [✨ Version 4.1.0 Schema Refinements](#-version-410-schema-refinements) for the current
> behaviour.

Between versions 2.0.0 and 4.0.0, the schema included manual temporal tracking capabilities to support
external data synchronisation operations, via a `date_refreshed` column on `ipsc_match` and a `date_edited`
column on `ipsc_match`, `match_competitor` and `match_stage_competitor`. Applications were responsible for
setting these columns whenever external data was imported or synchronised.

### ⏱️ Current Behaviour (v4.1.0+)

As of version 4.1.0, every core table's `date_created` and `date_updated` columns are managed entirely by
the database:

- `date_created` defaults to `CURRENT_TIMESTAMP` on insert.
- `date_updated` defaults to `CURRENT_TIMESTAMP` on insert and refreshes automatically on every subsequent
  update via `ON UPDATE CURRENT_TIMESTAMP`.

This removes the need for application code to set timestamps manually and guarantees `date_updated` always
reflects the true last-modified time — including for external synchronisation writes, since any `UPDATE`
statement refreshes it automatically:

```sql
UPDATE ipsc_match
SET match_category = 'Standard'
WHERE id = ?;
-- date_updated is refreshed automatically; no explicit timestamp column needs to be set.
```

## ⚠️ Normalisation & Breaking Changes

### 🧭 Version 2.0.0 Breaking Changes

As of version 2.0.0, the following changes enforce stricter database normalisation:

#### 🗑️ Removed Denormalised Columns

The following columns have been removed to eliminate data redundancy and enforce referential integrity:

- **ipsc_match.club_name** (removed in v2.0.0)
- **match_competitor.club** (removed in v2.0.0)

### 📌 Rationale

Storing `club_name` as a denormalised column in multiple tables introduces several risks:

1. **Data Inconsistency**: Club names could diverge across tables if not carefully maintained
2. **Update Anomalies**: Updating a club name would require changes across multiple tables
3. **Storage Waste**: The same club name is stored redundantly
4. **Foreign Key Enforcement**: Direct foreign key relationships are clearer and more maintainable

### 🛣️ Migration Path

Applications must be updated to retrieve club information via JOIN operations:

**Old approach (no longer supported):**

```sql
SELECT m.name, m.club_name, m.scheduled_date
FROM ipsc_match m
WHERE m.id = ?;
```

**New approach (required):**

```sql
SELECT m.name, c.name AS club_name, c.abbreviation, m.scheduled_date
FROM ipsc_match m
         INNER JOIN club c ON m.club_id = c.id
WHERE m.id = ?;
```

## 🚀 Schema Enhancements

### ✨ Version 4.0.0 Competitor Enhancements

As of version 4.0.0, the competitor table has been extended with additional contact and identification fields
to support comprehensive competitor profile management and multichannel communication:

#### 🆕 New Competitor Fields

- **`nickname`** (VARCHAR(255), optional) – Short name or handle for quick competitor identification
- **`gender`** (VARCHAR(36), optional) – Competitor gender classification for category and division management
  *(narrowed to `ENUM('Male', 'Female')` in v4.1.0 — see below)*
- **`club_number`** (VARCHAR(255), unique) – Club-specific competitor number with uniqueness enforcement
- **`id_number`** (VARCHAR(255), optional) – National identity or passport number for verification
- **`cellphone_number`** (VARCHAR(255), optional) – Primary mobile phone contact for notifications
- **`email_address`** (VARCHAR(255), optional) – Primary email address for communication
- **`secondary_email_address`** (VARCHAR(255), optional) – Secondary email address for backup notifications
  *(removed in v4.1.0 — see below)*

#### 📌 Rationale

These enhancements enable:

- **Enhanced Competitor Profiling**: Complete contact information facilitates direct communication with
  competitors for match notifications, results updates, and administrative matters.
- **Demographic Tracking**: Gender and nickname fields support better category management and user experience.
- **Identity Verification**: The `id_number` field supports membership verification and compliance requirements
  for federation-sanctioned events.
- **Club Administration**: The `club_number` field enables club-level competitor numbering systems with
  uniqueness enforcement to prevent duplicate registrations within a club.
- **Multi-Channel Outreach**: Multiple email addresses support alternative contact methods for notifications
  and result delivery.

#### ✅ Backward Compatibility

These enhancements are **fully backward compatible**. All new columns are optional/nullable, allowing existing
systems to adopt v4.0.0 without requiring immediate data migration. Applications can gradually populate these
fields as part of normal operations.

### ✨ Version 4.1.0 Schema Refinements

Version 4.1.0 refines the v4.0.0 competitor schema based on real-world data from the v4.0.0 seed import, and
standardises timestamp handling across every table.

#### 🔧 Competitor Changes

- **`gender`** – narrowed from free-text `VARCHAR(36)` to `ENUM('Male', 'Female')`, remaining nullable
- **`competitor_number`** – relaxed from `NOT NULL` to nullable, since this value is not always available
  at competitor creation time
- **`secondary_email_address`** – column removed; it was unused in practice
- **`uk_competitor_sapsa_number`** – unique constraint removed from `sapsa_number`, since not every real
  competitor record has a unique (or populated) SAPSA number

#### ⏱️ Timestamp Standardisation

- `date_created` / `date_updated` now default to `CURRENT_TIMESTAMP` (with `date_updated` refreshing via
  `ON UPDATE CURRENT_TIMESTAMP`) on `club`, `competitor`, `ipsc_match`, `ipsc_match_stage`,
  `match_competitor` and `match_stage_competitor` — see
  [⏱️ Temporal Tracking & Data Synchronisation](#-temporal-tracking--data-synchronisation)
- `ipsc_match.date_edited`, `ipsc_match.date_refreshed`, `match_competitor.date_edited` and
  `match_stage_competitor.date_edited` have been removed, superseded by the auto-managed `date_updated`

#### 📌 Rationale

- Real club data frequently has missing SAPSA numbers or competitor numbers — enforcing uniqueness or
  `NOT NULL` on these caused avoidable insert failures rather than genuine data-quality signals.
- Constraining `gender` to a fixed `ENUM` prevents inconsistent free-text values going forward while still
  allowing `NULL` for unknown values.
- A single, database-managed `date_updated` column is more reliable than relying on application code to set
  `date_edited`/`date_refreshed` manually, and removes redundant columns.

#### ⚠️ Breaking Changes

Unlike v4.0.0, these changes are **not fully backward compatible**:

- `secondary_email_address` data is lost when the column is dropped — back it up before upgrading if it is
  still required.
- Existing `gender` values outside `'Male'`/`'Female'` must be cleaned up before the `ENUM` conversion will
  succeed.
- Application logic that relied on the database to enforce SAPSA number uniqueness must implement that
  check itself going forward.
- Code reading `date_edited`/`date_refreshed` must be updated to use `date_updated` instead.

See [RELEASE_NOTES.md](RELEASE_NOTES.md#-upgrade-guide) for the full upgrade guide.

---

## 💡 Design Philosophy

This change reflects the project's commitment to **database normalisation best practices**. By enforcing
JOINs rather than storing redundant data, we ensure:

- A single source of truth for club information
- Automatic consistency across all references
- Simpler maintenance and schema evolution
- Better scalability for multi-club systems
