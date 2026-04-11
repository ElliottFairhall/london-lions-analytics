-- =============================================================================
-- UTL_LOG_EVENT
-- =============================================================================
-- Purpose:    Standardised logging procedure for the London Lions platform
-- =============================================================================

USE SCHEMA LIONS_DB.UTILS;

CREATE OR REPLACE PROCEDURE UTL_LOG_EVENT(
    LEVEL STRING,
    MESSAGE STRING,
    PROCEDURE_NAME STRING DEFAULT NULL,
    TAGS STRING DEFAULT NULL
)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    -- 1. Insert into persistent log table
    INSERT INTO LIONS_DB.UTILS.INGESTION_LOG (LEVEL, MESSAGE, PROCEDURE_NAME, TAGS)
    VALUES (:LEVEL, :MESSAGE, :PROCEDURE_NAME, :TAGS);

    -- 2. Emit system log for telemetry
    CASE UPPER(:LEVEL)
        WHEN 'INFO'  THEN SYSTEM$LOG_INFO(:MESSAGE || ' | Proc: ' || IFNULL(:PROCEDURE_NAME, 'N/A'));
        WHEN 'WARN'  THEN SYSTEM$LOG_WARN(:MESSAGE || ' | Proc: ' || IFNULL(:PROCEDURE_NAME, 'N/A'));
        WHEN 'ERROR' THEN SYSTEM$LOG_ERROR(:MESSAGE || ' | Proc: ' || IFNULL(:PROCEDURE_NAME, 'N/A'));
        ELSE SYSTEM$LOG(:LEVEL, :MESSAGE || ' | Proc: ' || IFNULL(:PROCEDURE_NAME, 'N/A'));
    END CASE;

    RETURN 'Logged: ' || :LEVEL;
END
$$;
