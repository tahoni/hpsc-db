#---------------------------------------------------------------------------------------------------
# 2026-03-13
#---------------------------------------------------------------------------------------------------

-- Drop tables for schema v1.0.0 in foreign-key-safe order
DROP TABLE IF EXISTS ipsc_match_stage_match_stage_competitors;
DROP TABLE IF EXISTS competitor_competitor_stage_matches;
DROP TABLE IF EXISTS ipsc_match_match_competitors;
DROP TABLE IF EXISTS competitor_competitor_matches;
DROP TABLE IF EXISTS ipsc_match_match_stages;
DROP TABLE IF EXISTS club_matches;
DROP TABLE IF EXISTS match_stage_competitor;
DROP TABLE IF EXISTS match_competitor;
DROP TABLE IF EXISTS ipsc_match_stage;
DROP TABLE IF EXISTS ipsc_match;
DROP TABLE IF EXISTS competitor;
DROP TABLE IF EXISTS club;

