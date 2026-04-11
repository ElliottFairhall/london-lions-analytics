-- =============================================================================
-- STG_TM_VALUATIONS
-- =============================================================================

USE SCHEMA LIONS_DB.STAGING;

CREATE OR REPLACE TABLE STG_TM_VALUATIONS (
    PLAYER_ID INTEGER,
    DATE DATE,
    MARKET_VALUE_IN_EUR INTEGER,
    CURRENT_CLUB_ID INTEGER,
    VALUATION_DATE_ID INTEGER,
    PLAYER_CLUB_DOMESTIC_COMPETITION_ID VARCHAR(20),
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Landing table for player market value history';

CREATE OR REPLACE STREAM STRM_TM_VALUATIONS ON TABLE STG_TM_VALUATIONS;
