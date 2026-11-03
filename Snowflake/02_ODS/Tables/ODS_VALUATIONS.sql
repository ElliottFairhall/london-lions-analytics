-- =============================================================================
-- ODS_VALUATIONS
-- =============================================================================
-- Purpose:    Operational Store for historical player valuations
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE TABLE IF NOT EXISTS ODS_VALUATIONS (
    VALUATION_ID VARCHAR(100) PRIMARY KEY, -- Composite key usually
    PLAYER_ID INTEGER,
    VALUATION_DATE DATE,
    MARKET_VALUE_EUR DECIMAL(15, 2),
    MD5_HASH VARCHAR(32),
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Operational Store for player valuation history';
