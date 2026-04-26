#---------------------------------------------------------------------------------------------------
# 2026-02-14 - 2026-02-21
#---------------------------------------------------------------------------------------------------

-- Add date_refreshed columns (2026-02-14, 2026-02-15)
ALTER TABLE ipsc_match
    ADD COLUMN date_refreshed DATETIME NULL;
ALTER TABLE match_competitor
    ADD COLUMN date_refreshed DATETIME NULL;
ALTER TABLE match_stage_competitor
    ADD COLUMN date_refreshed DATETIME NULL;

-- Remove redundant club_name columns (2026-02-21)
ALTER TABLE ipsc_match
    DROP COLUMN club_name;
ALTER TABLE match_competitor
    DROP COLUMN club;

-- Update the scheduled_date type to DATETIME (2026-02-21)
ALTER TABLE ipsc_match
    MODIFY COLUMN scheduled_date DATETIME NOT NULL;

-- Align date_created/date_updated definitions with table_create-v1.1.0.sql (2026-02-23)
-- Ensure TIMESTAMP types with appropriate defaults across all relevant tables.

-- Club table: ensure date_created/date_updated exist with TIMESTAMP defaults
ALTER TABLE club
    ADD COLUMN date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Competitor table: normalise date_created/date_updated to TIMESTAMP
ALTER TABLE competitor
    MODIFY COLUMN date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- IPSC match stage table: add or normalise date_created/date_updated to TIMESTAMP
ALTER TABLE ipsc_match_stage
    MODIFY COLUMN date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- IPSC match table: normalise date_created/date_updated to TIMESTAMP
ALTER TABLE ipsc_match
    MODIFY COLUMN date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Match competitor table: normalise date_created/date_updated to TIMESTAMP
ALTER TABLE match_competitor
    MODIFY COLUMN date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Match stage competitor table: normalise date_created/date_updated to TIMESTAMP
ALTER TABLE match_stage_competitor
    MODIFY COLUMN date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
