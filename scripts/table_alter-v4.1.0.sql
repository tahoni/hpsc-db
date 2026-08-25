#---------------------------------------------------------------------------------------------------
# 2026-05-31
#---------------------------------------------------------------------------------------------------

ALTER TABLE competitor
    MODIFY COLUMN competitor_number VARCHAR(255) NULL,
    MODIFY COLUMN gender ENUM ('Male', 'Female') NULL;
ALTER TABLE competitor
    DROP COLUMN secondary_email_address;
ALTER TABLE competitor
    DROP CONSTRAINT uk_competitor_sapsa_number;
ALTER TABLE competitor
    MODIFY date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

alter table club
    MODIFY date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE ipsc_match
    DROP COLUMN date_edited,
    DROP COLUMN date_refreshed;
alter table ipsc_match
    MODIFY column date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY column date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

alter table ipsc_match_stage
    MODIFY column date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MODIFY column date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE match_competitor
    DROP COLUMN date_edited;
alter table match_competitor
    modify column date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modify column date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE match_stage_competitor
    DROP COLUMN date_edited;
alter table match_stage_competitor
    modify column date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modify column date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
