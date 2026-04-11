-- =============================================================================
-- ODS_APPEARANCES
-- =============================================================================
-- Purpose:    Operational Store for match-level player performance
-- MD5:        MD5_HASH computed from key performance metrics for change detection
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE TABLE ODS_APPEARANCES (
    APPEARANCE_ID VARCHAR(50) PRIMARY KEY,
    GAME_ID INTEGER,
    PLAYER_ID INTEGER,
    CLUB_ID INTEGER,
    MATCH_DATE DATE,
    MINUTES_PLAYED INTEGER,
    GOALS INTEGER,
    ASSISTS INTEGER,
    YELLOW_CARDS INTEGER,
    RED_CARDS INTEGER,
    MD5_HASH VARCHAR(32),
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Operational Store for match-level player statistics with MD5 change tracking';
