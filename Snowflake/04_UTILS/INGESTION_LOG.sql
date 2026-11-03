-- =============================================================================
-- INGESTION_LOG
-- =============================================================================

USE SCHEMA LIONS_DB.UTILS;

CREATE TABLE IF NOT EXISTS INGESTION_LOG (
    LOG_ID INTEGER IDENTITY (1, 1) PRIMARY KEY,
    LOG_MESSAGE TEXT,
    LOG_TS TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
