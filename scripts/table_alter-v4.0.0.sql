#---------------------------------------------------------------------------------------------------
# 2026-05-31
#---------------------------------------------------------------------------------------------------

ALTER TABLE competitor
    ADD COLUMN nickname                VARCHAR(255) AFTER middle_names,
    ADD COLUMN gender                  VARCHAR(36) AFTER date_of_birth,
    ADD COLUMN club_number             VARCHAR(255) AFTER competitor_number,
    ADD COLUMN id_number               VARCHAR(255) AFTER club_number,
    ADD COLUMN cellphone_number        VARCHAR(255) AFTER id_number,
    ADD COLUMN email_address           VARCHAR(255) AFTER cellphone_number,
    ADD COLUMN secondary_email_address VARCHAR(255) AFTER email_address,
    ADD CONSTRAINT uk_competitor_club_number UNIQUE (club_number);
