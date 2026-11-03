-- =============================================================================
-- ODS_PLAYERS
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE TABLE IF NOT EXISTS ODS_PLAYERS (
    PLAYER_ID INTEGER PRIMARY KEY,
    FIRST_NAME VARCHAR(255),
    LAST_NAME VARCHAR(255),
    NAME VARCHAR(255),
    DATE_OF_BIRTH DATE,
    POSITION VARCHAR(50),
    FOOT VARCHAR(20),
    HEIGHT_IN_CM INTEGER,
    PLAYER_CODE VARCHAR(100),
    CURRENT_CLUB_ID INTEGER,
    MARKET_VALUE_IN_EUR INTEGER,
    MD5_HASH VARCHAR(32),
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_TS TIMESTAMP_NTZ
)
COMMENT = 'Operational Store for Player master data';
