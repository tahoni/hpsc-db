#---------------------------------------------------------------------------------------------------
# 2026-01-21
#---------------------------------------------------------------------------------------------------

# Club
create table if not exists club
(
    id           int auto_increment primary key,
    name         varchar(255) not null,
    abbreviation varchar(255) null,
    constraint club_name_uindex unique (name),
    constraint club_abbreviation_uindex unique (abbreviation)
);

# Competitor
create table if not exists competitor
(
    id                int auto_increment primary key,
    first_name        varchar(255) not null,
    last_name         varchar(255) not null,
    middle_names      varchar(255) not null,
    competitor_number varchar(255) not null,
    sapsa_number      int          null,
    category          varchar(255) null,
    constraint competitor_sapsa_number_uindex unique (sapsa_number),
    constraint competitor_full_name_uindex unique index (first_name, middle_names, last_name)
);

# Match
create table if not exists `match`
(
    id             int auto_increment primary key,
    club_id        int          not null,
    name           varchar(255) not null,
    scheduled_date date         not null,
    match_division varchar(255) null,
    match_category varchar(255) null,
    foreign key (club_id) references club (id),
    constraint match_club_id_name_scheduled_date_uindex unique (club_id, name, scheduled_date)
);

# Match Stage
create table if not exists match_stage
(
    id           int auto_increment primary key,
    match_id     int not null,
    stage_number int not null,
    range_number int null,
    foreign key (match_id) references `match` (id),
    constraint match_stage_match_id_stage_number_uindex unique (match_id, stage_number)
);

# Match Competitor
create table if not exists match_competitor
(
    id               int auto_increment primary key,
    match_id         int            not null,
    competitor_id    int            not null,
    division         varchar(255)   null,
    discipline       varchar(255)   null,
    power_factor     varchar(255)   null,
    match_points     decimal(10, 4) null,
    match_percentage decimal(10, 2) null,
    foreign key (match_id) references `match` (id),
    foreign key (competitor_id) references competitor (id),
    constraint match_competitor_match_id_competitor_id_uindex unique (match_id, competitor_id)
);

# Match Stage Competitor
create table if not exists match_stage_competitor
(
    id                  int auto_increment primary key,
    match_stage_id      int            not null,
    match_competitor_id int            not null,
    points              int            null,
    penalties           int            null,
    time                decimal(10, 2) null,
    hit_factor          decimal(10, 4) null,
    stage_points        decimal(10, 4) null,
    stage_percentage    decimal(10, 2) null,
    foreign key (match_stage_id) references match_stage (id),
    foreign key (match_competitor_id) references match_competitor (id),
    constraint match_stage_competitor_match_stage_id_competitor_id_uindex
        unique (match_stage_id, match_competitor_id)
);

#---------------------------------------------------------------------------------------------------
# 2026-01-28
#---------------------------------------------------------------------------------------------------

# Log Match
create table if not exists log_match
(
    id            int auto_increment primary key,
    competitor_id int            not null,
    match_id      int            not null,
    place         int            null,
    points        decimal(10, 4) null,
    percentage    decimal(10, 2) null,
    foreign key (competitor_id) references competitor (id),
    foreign key (match_id) references `match` (id),
    constraint log_match_competitor_id_match_id_uindex unique (competitor_id, match_id)
);

# Log Matches
create table if not exists log_matches
(
    id            int auto_increment primary key,
    competitor_id int            not null,
    min_match_id  int            not null,
    max_match_id  int            not null,
    place         int            null,
    points        decimal(10, 4) null,
    percentage    decimal(10, 2) null,
    foreign key (competitor_id) references competitor (id),
    foreign key (min_match_id) references `match` (id),
    foreign key (max_match_id) references `match` (id),
    constraint log_matches_competitor_id_min_match_id_max_match_id_uindex
        unique (competitor_id, min_match_id, max_match_id)
);
