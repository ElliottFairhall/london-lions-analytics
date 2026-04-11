-- =============================================================================
-- FCT_VALUATIONS
-- =============================================================================

USE SCHEMA LIONS_DB.DOMAIN;

CREATE OR REPLACE TABLE FCT_VALUATIONS (
    VALUATION_KEY INTEGER IDENTITY (1, 1) PRIMARY KEY,
    PLAYER_KEY INTEGER REFERENCES DIM_PLAYER (PLAYER_KEY),
    VALUATION_DATE DATE,
    MARKET_VALUE_EUR DECIMAL(15, 2),
    VALUATION_DELTA_EUR DECIMAL(15, 2), -- Potential calculation field
    DW_INSERT_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Fact table tracking historical player market values';
