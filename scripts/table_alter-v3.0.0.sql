#---------------------------------------------------------------------------------------------------
# 2026-03-13
#---------------------------------------------------------------------------------------------------

-- Drop unique constraint/index on ipsc_match.name (legacy schema compatibility)
-- Resolves the actual unique index name first, then drops it if present.
SET @ipsc_match_name_unique_idx := (SELECT s.INDEX_NAME
                                    FROM INFORMATION_SCHEMA.STATISTICS s
                                    WHERE s.TABLE_SCHEMA = DATABASE()
                                      AND s.TABLE_NAME = 'ipsc_match'
                                      AND s.COLUMN_NAME = 'name'
                                      AND s.NON_UNIQUE = 0
                                    LIMIT 1);

SET @ipsc_match_drop_unique_sql := IF(
        @ipsc_match_name_unique_idx IS NOT NULL,
        CONCAT('ALTER TABLE ipsc_match DROP INDEX `', @ipsc_match_name_unique_idx, '`'),
        'SELECT ''No unique index found on ipsc_match.name'''
                                   );

PREPARE stmt_drop_ipsc_match_name_unique FROM @ipsc_match_drop_unique_sql;
EXECUTE stmt_drop_ipsc_match_name_unique;
DEALLOCATE PREPARE stmt_drop_ipsc_match_name_unique;
