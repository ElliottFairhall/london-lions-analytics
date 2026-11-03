-- =============================================================================
-- DIM_CLUB
-- =============================================================================

USE SCHEMA LIONS_DB.DOMAIN;

CREATE TABLE IF NOT EXISTS DIM_CLUB (
    CLUB_KEY INTEGER IDENTITY (1, 1) PRIMARY KEY,
    TM_CLUB_ID INTEGER UNIQUE,
    CLUB_NAME VARCHAR(255),
    STADIUM_NAME VARCHAR(100),
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Club dimension for analytical reporting';
