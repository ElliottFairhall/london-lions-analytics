-- =============================================================================
-- DIM_PLAYER
-- =============================================================================

USE SCHEMA LIONS_DB.DOMAIN;

CREATE OR REPLACE TABLE DIM_PLAYER (
    PLAYER_KEY INTEGER IDENTITY (1, 1) PRIMARY KEY,
    TM_PLAYER_ID INTEGER,
    PLAYER_NAME VARCHAR(255),
    POSITION VARCHAR(50),
    CURRENT_CLUB_NAME VARCHAR(100),
    MARKET_VALUE_EUR DECIMAL(15, 2),

    -- Change Detection
    MD5_HASH VARCHAR(32),

    -- SCD Type 2 fields
    EFFECTIVE_FROM TIMESTAMP_NTZ,
    EFFECTIVE_TO TIMESTAMP_NTZ,
    IS_CURRENT BOOLEAN,

    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Slowly Changing Dimension for Players using MD5 hashing for change detection';
