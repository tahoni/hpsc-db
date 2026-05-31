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
    - [🗃️ Logging and Summary Tables](#-logging-and-summary-tables)
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
    - Stores identity fields and identifiers, including SAPSA membership numbers and club-specific competitor
      numbers.
    - As of version 4.0.0, it supports comprehensive contact information (cellphone, email) and demographic data
      (gender, nickname).
    - Uniqueness constraints reduce accidental duplicates and enforce federation membership compliance
      (e.g. unique SAPSA numbers, unique club-specific competitor numbers).

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

### 🗃️ Logging and Summary Tables

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

Logging tables reference competitor and match (or match ranges) to maintain provenance.

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
    - Persist leaderboard snapshots in `log_match` and `log_matches`.

Which approach you choose depends on scale, performance needs, and whether you want immutable historical
snapshots.

The approach used in this project is **compute-and-store**.

## ⏱️ Temporal Tracking & Data Synchronisation

As of version 2.0.0, the schema includes temporal tracking capabilities to support external data
synchronisation operations. The following tables now include a `date_refreshed` column:

- **ipsc_match**: Tracks when match data was last synchronised with external sources
- **match_competitor**: Tracks when competitor match data was last updated
- **match_stage_competitor**: Tracks when stage results were last refreshed

### 🎯 Purpose

The `date_refreshed` field (nullable DATETIME) serves as an audit trail for data integration workflows. This
is particularly important for systems that import results from external platforms, scoring devices, or
third-party match management systems. By recording refresh timestamps, you can:

- Identify stale data that may require re-synchronisation
- Audit the currency of results
- Implement selective refresh strategies for high-frequency integrations
- Track synchronisation patterns and troubleshoot integration issues

### 🧪 Usage

Applications should update `date_refreshed` whenever external data is imported or synchronised:

```sql
UPDATE ipsc_match
SET date_refreshed = NOW()
WHERE id = ?;
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
- **`club_number`** (VARCHAR(255), unique) – Club-specific competitor number with uniqueness enforcement
- **`id_number`** (VARCHAR(255), optional) – National identity or passport number for verification
- **`cellphone_number`** (VARCHAR(255), optional) – Primary mobile phone contact for notifications
- **`email_address`** (VARCHAR(255), optional) – Primary email address for communication
- **`secondary_email_address`** (VARCHAR(255), optional) – Secondary email address for backup notifications

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

---

## 💡 Design Philosophy

This change reflects the project's commitment to **database normalisation best practices**. By enforcing
JOINs rather than storing redundant data, we ensure:

- A single source of truth for club information
- Automatic consistency across all references
- Simpler maintenance and schema evolution
- Better scalability for multi-club systems
