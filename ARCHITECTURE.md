# HPSC Database Architecture

This document describes the architectural design, directory structure, and core concepts
of the database used by the Hartbeespoortdam Practical Shooting Club (HPSC) website.

## Table of Contents

- [Introduction](#introduction)
- [Target Database](#target-database)
- [Project Structure](#project-structure)
- [Goals](#goals)
- [Data Model Overview](#data-model-overview)
    - [Core Domain Tables](#core-domain-tables)
    - [Participation and Scoring Tables](#participation-and-scoring-tables)
    - [Logging and Summary Tables](#logging-and-summary-tables)
- [Key Relationships (conceptual)](#key-relationships-conceptual)
- [Integrity Strategy](#integrity-strategy)
- [Aggregation Strategy](#aggregation-strategy)

## Introduction

This project is a **database-first** design centered on a normalised relational schema for shooting match
results and derived standings.

## Target Database

### Technical Requirements

- **Database engine**: **MySQL 8.x**
- **Storage engine**: **InnoDB**
- **Character set**: `utf8mb4`
- **Collation**: `utf8mb4_0900_ai_ci`

### Design Considerations

- Collation: use a consistent collation across environments (e.g., `utf8mb4_0900_ai_ci`)
- Time zone: keep server/app time zone consistent; store match dates as `DATE` (already aligned)

### Why MySQL / InnoDB

- Foreign keys and transactional integrity for match → stage → results relationships
- Good support for indexing and uniqueness constraints used to prevent duplicate entries
- Operationally simple for local development and small deployments

## Project Structure

```text
├───documentation       # Project documentation and templates
└───scripts             # Database scripts, including baseline schema and change scripts.
```

## Goals

- Represent matches, stages, competitors, and clubs with clear ownership.
- Prevent duplicates via foreign keys and uniqueness constraints.
- Support both **raw scoring data** (stage results) and **derived summaries** (match totals, logs).

## Data Model Overview

### Core Domain Tables

- **club**
    - Represents an organising club.
    - Unique identity is enforced (e.g. by name and abbreviation).

- **competitor**
    - Represents an athlete/person.
    - Stores identity fields and identifiers (including an optional association number).
    - Uniqueness constraints reduce accidental duplicates.

- **match**
    - Represents a scheduled event hosted by a club.
    - Tied to a club via a foreign key.
    - Uniqueness is enforced per club and date/name to avoid duplicate matches.

- **match_stage**
    - Represents a stage within a match.
    - Stage numbering is unique per match.

### Participation and Scoring Tables

- **match_competitor**
    - A join table between match and competitor (a competitor’s participation in a match).
    - Stores match-level attributes (division/discipline/power factor).
    - Stores match-level results (points, percentage) if computed externally or as a persisted aggregate.

- **match_stage_competitor**
    - Associates a competitor-in-match with a match stage.
    - Stores stage metrics (points, penalties, time, hit factor) and optional persisted aggregates
      (stage points/percentage).

### Logging and Summary Tables

- **log_match**
    - Snapshot/summary of competitor performance for a single match (place, points, percentage).
    - Useful for quick leaderboard access without recomputation.

- **log_matches**
    - Snapshot/summary across a window of matches (min_match_id → max_match_id).
    - Useful for series scoring, season windows, or rolling comparisons.

## Key Relationships (conceptual)

- club 1 → N match
- match 1 → N match_stage
- competitor N ↔ N match (via match_competitor)
- match_stage 1 → N match_stage_competitor
- match_competitor 1 → N match_stage_competitor

Logging tables reference competitor and match (or match ranges) to maintain provenance.

## Integrity Strategy

- **Primary keys**: surrogate integer IDs for stable references.
- **Foreign keys**: enforce that dependent rows cannot exist without parents.
    - In MySQL, foreign keys require InnoDB.
- **Unique constraints**: prevent duplicates in natural-key-like scenarios:
    - competitor enrollment per match
    - stage numbering per match
    - stage result uniqueness per (stage, competitor-in-match)
    - match uniqueness per (club, name, scheduled_date)

## Aggregation Strategy

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
