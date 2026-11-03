-- =============================================================================
-- LOGGING TABLE SETUP
-- =============================================================================
-- Purpose:    Centralised event logging for the London Lions platform
-- =============================================================================

USE SCHEMA LIONS_DB.UTILS;

CREATE TABLE IF NOT EXISTS INGESTION_LOG (
    LOG_ID INTEGER IDENTITY (1, 1) PRIMARY KEY,
    EVENT_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    LEVEL STRING,           -- INFO, WARN, ERROR
    MESSAGE STRING,
    PROCEDURE_NAME STRING,
    TAGS STRING
)
COMMENT = 'Centralised logging for pipeline orchestration';
