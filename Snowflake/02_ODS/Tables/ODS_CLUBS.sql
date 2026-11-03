-- =============================================================================
-- ODS_CLUBS
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE TABLE IF NOT EXISTS ODS_CLUBS (
    CLUB_ID INTEGER PRIMARY KEY,
    CLUB_NAME VARCHAR(255),
    CLUB_CODE VARCHAR(100),
    DOMESTIC_COMPETITION_ID VARCHAR(20),
    TOTAL_MARKET_VALUE_EUR DECIMAL(20, 2),
    STADIUM_NAME VARCHAR(100),
    MD5_HASH VARCHAR(32),
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_TS TIMESTAMP_NTZ
)
COMMENT = 'Operational Store for Club metadata';
