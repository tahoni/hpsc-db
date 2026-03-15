#---------------------------------------------------------------------------------------------------
# 2026-03-14
#---------------------------------------------------------------------------------------------------

-- Delete all match data in foreign-key-safe order for schema v3.0.0
START TRANSACTION;

DELETE msc
FROM match_stage_competitor msc
         INNER JOIN ipsc_match_stage ims ON ims.id = msc.match_stage_id
         INNER JOIN ipsc_match im ON im.id = ims.match_id;

DELETE mc
FROM match_competitor mc
         INNER JOIN ipsc_match im ON im.id = mc.match_id;

DELETE ims
FROM ipsc_match_stage ims
         INNER JOIN ipsc_match im ON im.id = ims.match_id;

DELETE im
FROM ipsc_match im
         INNER JOIN (SELECT id FROM ipsc_match) matches_to_delete ON matches_to_delete.id = im.id;

COMMIT;

