#---------------------------------------------------------------------------------------------------
# 2026-05-31
#---------------------------------------------------------------------------------------------------

CREATE TABLE club
(
    id           BIGINT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(255) NOT NULL,
    abbreviation VARCHAR(255),
    date_created TIMESTAMP,
    date_updated TIMESTAMP,
    CONSTRAINT uk_club_name UNIQUE (name)
);

CREATE TABLE competitor
(
    id                      BIGINT PRIMARY KEY AUTO_INCREMENT,
    first_name              VARCHAR(255) NOT NULL,
    last_name               VARCHAR(255) NOT NULL,
    middle_names            VARCHAR(255),
    nickname                VARCHAR(255),
    date_of_birth           DATE,
    gender                  VARCHAR(36),
    sapsa_number            INTEGER,
    competitor_number       VARCHAR(255) NOT NULL,
    club_number             VARCHAR(255) NOT NULL,
    id_number               VARCHAR(255),
    cellphone_number        VARCHAR(255),
    email_address           VARCHAR(255),
    secondary_email_address VARCHAR(255),
    date_created            TIMESTAMP,
    date_updated            TIMESTAMP,
    CONSTRAINT uk_competitor_sapsa_number UNIQUE (sapsa_number),
    CONSTRAINT uk_competitor_club_number UNIQUE (club_number)
);

CREATE TABLE ipsc_match
(
    id                 BIGINT PRIMARY KEY AUTO_INCREMENT,
    club_id            BIGINT,
    name               VARCHAR(255) NOT NULL,
    scheduled_date     TIMESTAMP    NOT NULL,
    match_firearm_type VARCHAR(50),
    match_category     VARCHAR(50),
    date_created       TIMESTAMP,
    date_updated       TIMESTAMP,
    date_edited        TIMESTAMP,
    date_refreshed     TIMESTAMP,
    CONSTRAINT fk_ipsc_match_club FOREIGN KEY (club_id) REFERENCES club (id)
);

CREATE TABLE ipsc_match_stage
(
    id               BIGINT PRIMARY KEY AUTO_INCREMENT,
    match_id         BIGINT  NOT NULL,
    stage_number     INTEGER NOT NULL,
    stage_name       VARCHAR(255),
    range_number     INTEGER,
    target_paper     INTEGER,
    target_popper    INTEGER,
    target_plates    INTEGER,
    target_disappear INTEGER,
    target_penalty   INTEGER,
    min_rounds       INTEGER,
    max_points       INTEGER,
    date_created     TIMESTAMP,
    date_updated     TIMESTAMP,
    CONSTRAINT fk_ipsc_match_stage_match FOREIGN KEY (match_id) REFERENCES ipsc_match (id)
);

CREATE TABLE match_competitor
(
    id                  BIGINT PRIMARY KEY AUTO_INCREMENT,
    competitor_id       BIGINT NOT NULL,
    match_id            BIGINT NOT NULL,
    match_club          VARCHAR(50),
    firearm_type        VARCHAR(50),
    division            VARCHAR(50),
    power_factor        VARCHAR(50),
    match_points        NUMERIC(19, 6),
    match_ranking       NUMERIC(19, 6),
    competitor_category VARCHAR(50),
    date_created        TIMESTAMP,
    date_updated        TIMESTAMP,
    date_edited         TIMESTAMP,
    CONSTRAINT fk_match_competitor_competitor FOREIGN KEY (competitor_id) REFERENCES competitor (id),
    CONSTRAINT fk_match_competitor_match FOREIGN KEY (match_id) REFERENCES ipsc_match (id)
);

CREATE TABLE match_stage_competitor
(
    id                   BIGINT PRIMARY KEY AUTO_INCREMENT,
    competitor_id        BIGINT NOT NULL,
    match_stage_id       BIGINT NOT NULL,
    match_club           VARCHAR(50),
    firearm_type         VARCHAR(50),
    division             VARCHAR(50),
    power_factor         VARCHAR(50),
    score_a              INTEGER,
    score_b              INTEGER,
    score_c              INTEGER,
    score_d              INTEGER,
    points               INTEGER,
    misses               INTEGER,
    penalties            INTEGER,
    procedurals          INTEGER,
    has_deduction        BOOLEAN,
    deduction_percentage NUMERIC(19, 6),
    time                 NUMERIC(19, 6),
    hit_factor           NUMERIC(19, 6),
    stage_points         NUMERIC(19, 6),
    stage_percentage     NUMERIC(19, 6),
    stage_ranking        NUMERIC(19, 6),
    is_disqualified      BOOLEAN,
    competitor_category  VARCHAR(50),
    date_created         TIMESTAMP,
    date_updated         TIMESTAMP,
    date_edited          TIMESTAMP,
    CONSTRAINT fk_match_stage_competitor_competitor FOREIGN KEY (competitor_id) REFERENCES competitor (id),
    CONSTRAINT fk_match_stage_competitor_stage FOREIGN KEY (match_stage_id) REFERENCES ipsc_match_stage (id)
);

CREATE INDEX idx_ipsc_match_club_id ON ipsc_match (club_id);
CREATE INDEX idx_ipsc_match_stage_match_id ON ipsc_match_stage (match_id);
CREATE INDEX idx_match_competitor_competitor_id ON match_competitor (competitor_id);
CREATE INDEX idx_match_competitor_match_id ON match_competitor (match_id);
CREATE INDEX idx_match_stage_competitor_competitor_id ON match_stage_competitor (competitor_id);
CREATE INDEX idx_match_stage_competitor_match_stage_id ON match_stage_competitor (match_stage_id);
