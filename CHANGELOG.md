# HPSC Database

## Change Log

### Table of Contents

- [Version 1.0.0](#version-100---_2026-01-28_)

### [Version 1.0.0](https://github.com/tahoni/hpsc-db/releases/tag/version-1.0.0) - _2026-01-28_

Extended the database schema to better support match/stage scoring, placing, and disqualification tracking.

#### Enhancements and Updates

- **Competitor**
    - Make `sapsa_number` optional (nullable, stored as `varchar(255)`).
    - Add `place` (nullable) to store competitor placing where relevant.

- **Match competitor**
    - Add `is_disqualified` (nullable boolean) to flag DQ status at match level.
    - Add `place` (nullable) for match-level placing.

- **Match stage competitor**
    - Add per-stage score buckets: `score_a`, `score_b`, `score_c`, `score_d` (nullable ints).
    - Add penalty detail fields: `misses`, `procedurals` (nullable ints).
    - Add `is_disqualified` (nullable boolean) for stage-level DQ tracking.

#### Licence and Documentation

- Created the `README.md` and `ARCHITECTURE.md` files.
- Added documentation templates for `CHANGELOG.md` and `RELEASE_NOTES.md`.
- Added a `suggestions.md` file for future enhancements.

#### Changes by

@tahoni
