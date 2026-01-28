# HPSC Database

The official repository for the Hartbeespoortdam Practical Shooting Club (HPSC) database schema.

## Table of contents

- [Introduction](#introduction)
- [Schema Entities](#schema-entities)
- [Quick Start (DataGrip)](#quick-start-datagrip)
- [Conventions and Constraints](#conventions-and-constraints)
- [Typical Workflows Supported](#typical-workflows-supported)
- [Architecture](#architecture)
- [License](#license)
- [Author](#author)

## Introduction

This repository contains a relational database schema for managing shooting match results:
clubs, competitors, matches, stages, per-match competitor performance, and per-stage scores.
It also includes logging tables for derived/aggregated competitor standings across matches.

## Schema Entities

- **Core entities**
    - **Club**: organizing entity (name, abbreviation).
    - **Competitor**: person identity and competitor identifiers (e.g. competitor number, optional SAPSA
      number)
      and optional category.
    - **Match**: a scheduled match hosted by a club (name/date and optional division/category).
    - **Match stage**: stages within a match (stage number, optional range number).

- **Results**
    - **Match competitor**: a competitor’s participation in a specific match, including
      division/discipline/power factor and overall match points/percentage.
    - **Match stage competitor**: stage-level performance for a match competitor (points, penalties,
      time, hit factor, stage points/percentage).

- **Logging / derived standings**
    - **Log match**: per-competitor results for a single match (place, points, percentage).
    - **Log matches**: per-competitor results across a match range/window (min/max match IDs and
      place/points/percentage).

## Quick Start (DataGrip)

1. Create or select a database/schema (e.g. MySQL-compatible).
2. Open the SQL migration/schema file(s) in DataGrip.
3. Run the script against your target database.
4. Verify tables and relationships in the **Database Explorer** diagram view (helps confirm foreign keys and
   uniqueness constraints).

## Conventions and Constraints

- Tables use integer auto-increment primary keys.
- Foreign keys enforce referential integrity between:
    - match → club
    - match_stage → match
    - match_competitor → match, competitor
    - match_stage_competitor → match_stage, match_competitor
    - log tables → competitor, match (and match ranges)
- Uniqueness constraints prevent duplicates such as:
    - duplicate club names/abbreviations
    - duplicate competitor identity composites / identifiers
    - duplicate match identity within a club by (club, name, scheduled_date)
    - duplicate competitor enrollment per match
    - duplicate stage result rows per (stage, competitor-in-match)

## Typical Workflows Supported

- Register clubs and competitors.
- Create matches and stages for a scheduled event.
- Record competitors participating in a match (division/discipline/power factor).
- Record stage-by-stage scoring and compute stage/match aggregates (or store them when computed elsewhere).
- Store leaderboard snapshots in log tables (single match or match window).

## Architecture

A detailed explanation of the architecture can be found in the [`ARCHITECTURE.md`](ARCHITECTURE.md) file.

## License

The copyright licence can be found in the [`LICENSE.md`](LICENSE.md) file.

## Author

**Leoni Lubbinge**

- [![Website Badge](https://custom-icon-badges.demolab.com/badge/https%3A%2F%2Ftahoni.info-blue?logo=file-code)](https://www.tahoni.info)
- [![Email Badge](https://custom-icon-badges.demolab.com/badge/leonil%40tahoni.info-blue?logo=mail)](mailto:leonil@tahoni.info)


- [![Gmail Badge](https://img.shields.io/badge/tahoni%40gmail.com-blue?logo=gmail)](mailto:tahoni@gmail.com)
- [![GitHub Badge](https://img.shields.io/badge/Leoni_Lubbinge-blue?logo=github)](https://github.com/tahoni)
- [![LinkedIn Badge](https://custom-icon-badges.demolab.com/badge/Leoni_Lubbinge-blue.svg?logoSource=feather&logo=linkedin)](https://www.linkedin.com/in/leoni-lubbinge-06066b16/)
