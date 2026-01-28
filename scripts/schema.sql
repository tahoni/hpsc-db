#---------------------------------------------------------------------------------------------------
# 2026-01-21
#---------------------------------------------------------------------------------------------------

# HPSC Development database schema
create schema if not exists hpsc_dev;
create user if not exists hpsc_dev@localhost identified by '????';
grant select, insert, update, delete on hpsc_dev.* to hpsc_dev@localhost;

# HPSC Production database schema
create schema if not exists hpsc_prod;
create user if not exists hpsc_prod@localhost identified by '????';
grant select, insert, update, delete on hpsc_prod.* to hpsc_prod@localhost;
