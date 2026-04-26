#---------------------------------------------------------------------------------------------------
# 2026-02-01 - 2026-02-15
#---------------------------------------------------------------------------------------------------

-- Club table
CREATE TABLE IF NOT EXISTS club
(
    id           BIGINT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(255) NOT NULL UNIQUE,
    abbreviation VARCHAR(255),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- IpscMatch table
CREATE TABLE IF NOT EXISTS ipsc_match
(
    id                 BIGINT PRIMARY KEY AUTO_INCREMENT,
    club_id            BIGINT       NULL,
    name               VARCHAR(255) NOT NULL,
    scheduled_date     DATETIME     NOT NULL,
    match_firearm_type VARCHAR(255),
    match_category     VARCHAR(255),
    date_created       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    date_edited        DATETIME,
    date_refreshed     DATETIME     NULL,
    FOREIGN KEY (club_id) REFERENCES club (id)
);

-- Competitor table
CREATE TABLE IF NOT EXISTS competitor
(
    id                          BIGINT PRIMARY KEY AUTO_INCREMENT,
    first_name                  VARCHAR(255) NOT NULL,
    last_name                   VARCHAR(255) NOT NULL,
    middle_names                VARCHAR(255),
    date_of_birth               DATE,
    sapsa_number                INT,
    competitor_number           VARCHAR(255) NOT NULL,
    default_competitor_category VARCHAR(255),
    date_created                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated                TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- IpscMatchStage table
CREATE TABLE IF NOT EXISTS ipsc_match_stage
(
    id               BIGINT PRIMARY KEY AUTO_INCREMENT,
    match_id         BIGINT NOT NULL,
    stage_number     INT    NOT NULL,
    stage_name       VARCHAR(255),
    range_number     INT,
    target_paper     INT,
    target_popper    INT,
    target_plates    INT,
    target_disappear INT,
    target_penalty   INT,
    min_rounds       INT,
    max_points       INT,
    date_created     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (match_id) REFERENCES ipsc_match (id)
);

-- MatchCompetitor table
CREATE TABLE IF NOT EXISTS match_competitor
(
    id                  BIGINT PRIMARY KEY AUTO_INCREMENT,
    competitor_id       BIGINT   NOT NULL,
    match_id            BIGINT   NOT NULL,
    firearm_type        VARCHAR(255),
    division            VARCHAR(255),
    power_factor        VARCHAR(255),
    match_points        DECIMAL(19, 2),
    match_ranking       DECIMAL(19, 2),
    competitor_category VARCHAR(255),
    date_created        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    date_edited         DATETIME,
    date_refreshed      DATETIME NULL,
    FOREIGN KEY (competitor_id) REFERENCES competitor (id),
    FOREIGN KEY (match_id) REFERENCES ipsc_match (id)
);

-- MatchStageCompetitor table
CREATE TABLE IF NOT EXISTS match_stage_competitor
(
    id                   BIGINT PRIMARY KEY AUTO_INCREMENT,
    competitor_id        BIGINT   NOT NULL,
    match_stage_id       BIGINT   NOT NULL,
    firearm_type         VARCHAR(255),
    division             VARCHAR(255),
    power_factor         VARCHAR(255),
    score_a              INT,
    score_b              INT,
    score_c              INT,
    score_d              INT,
    points               INT,
    misses               INT,
    penalties            INT,
    procedurals          INT,
    has_deduction        BOOLEAN,
    deduction_percentage DECIMAL(19, 2),
    time                 DECIMAL(19, 2),
    hit_factor           DECIMAL(19, 2),
    stage_points         DECIMAL(19, 2),
    stage_percentage     DECIMAL(19, 2),
    stage_ranking        DECIMAL(19, 2),
    is_disqualified      BOOLEAN,
    competitor_category  VARCHAR(255),
    date_created         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    date_edited          DATETIME,
    date_refreshed       DATETIME NULL,
    FOREIGN KEY (competitor_id) REFERENCES competitor (id),
    FOREIGN KEY (match_stage_id) REFERENCES ipsc_match_stage (id)
);

-- Join tables for OneToMany relationships
CREATE TABLE IF NOT EXISTS club_matches
(
    club_id    BIGINT NOT NULL,
    matches_id BIGINT NOT NULL,
    FOREIGN KEY (club_id) REFERENCES club (id),
    FOREIGN KEY (matches_id) REFERENCES ipsc_match (id)
);

CREATE TABLE IF NOT EXISTS ipsc_match_match_stages
(
    ipsc_match_id   BIGINT NOT NULL,
    match_stages_id BIGINT NOT NULL,
    FOREIGN KEY (ipsc_match_id) REFERENCES ipsc_match (id),
    FOREIGN KEY (match_stages_id) REFERENCES ipsc_match_stage (id)
);

CREATE TABLE IF NOT EXISTS ipsc_match_stage_match_stage_competitors
(
    ipsc_match_stage_id        BIGINT NOT NULL,
    match_stage_competitors_id BIGINT NOT NULL,
    FOREIGN KEY (ipsc_match_stage_id) REFERENCES ipsc_match_stage (id),
    FOREIGN KEY (match_stage_competitors_id) REFERENCES match_stage_competitor (id),
    PRIMARY KEY (ipsc_match_stage_id, match_stage_competitors_id)
);

CREATE TABLE IF NOT EXISTS ipsc_match_match_competitors
(
    ipsc_match_id        BIGINT NOT NULL,
    match_competitors_id BIGINT NOT NULL,
    FOREIGN KEY (ipsc_match_id) REFERENCES ipsc_match (id),
    FOREIGN KEY (match_competitors_id) REFERENCES match_competitor (id)
);

CREATE TABLE IF NOT EXISTS competitor_competitor_matches
(
    competitor_id         BIGINT NOT NULL,
    competitor_matches_id BIGINT NOT NULL,
    FOREIGN KEY (competitor_id) REFERENCES competitor (id),
    FOREIGN KEY (competitor_matches_id) REFERENCES match_competitor (id)
);

CREATE TABLE IF NOT EXISTS competitor_competitor_stage_matches
(
    competitor_id               BIGINT NOT NULL,
    competitor_stage_matches_id BIGINT NOT NULL,
    FOREIGN KEY (competitor_id) REFERENCES competitor (id),
    FOREIGN KEY (competitor_stage_matches_id) REFERENCES match_stage_competitor (id)
);
