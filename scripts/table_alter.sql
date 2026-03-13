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

-- Align date_created/date_updated definitions with table_create.sql (2026-02-23)
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


#---------------------------------------------------------------------------------------------------
# 2026-03-13
#---------------------------------------------------------------------------------------------------

-- Drop unique constraint/index on ipsc_match.name (legacy schema compatibility)
-- Resolves the actual unique index name first, then drops it if present.
SET @ipsc_match_name_unique_idx := (
    SELECT s.INDEX_NAME
    FROM INFORMATION_SCHEMA.STATISTICS s
    WHERE s.TABLE_SCHEMA = DATABASE()
      AND s.TABLE_NAME = 'ipsc_match'
      AND s.COLUMN_NAME = 'name'
      AND s.NON_UNIQUE = 0
    LIMIT 1
);

SET @ipsc_match_drop_unique_sql := IF(
    @ipsc_match_name_unique_idx IS NOT NULL,
    CONCAT('ALTER TABLE ipsc_match DROP INDEX `', @ipsc_match_name_unique_idx, '`'),
    'SELECT ''No unique index found on ipsc_match.name'''
);

PREPARE stmt_drop_ipsc_match_name_unique FROM @ipsc_match_drop_unique_sql;
EXECUTE stmt_drop_ipsc_match_name_unique;
DEALLOCATE PREPARE stmt_drop_ipsc_match_name_unique;
