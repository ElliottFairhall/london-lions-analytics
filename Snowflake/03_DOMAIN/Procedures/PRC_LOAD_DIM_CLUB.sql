-- =============================================================================
-- PRC_LOAD_DIM_CLUB
-- =============================================================================
-- Purpose:    Load DIM_CLUB from ODS_CLUBS (SCD Type 1)
-- Standards:  TechTrend logging, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.DOMAIN;

CREATE OR REPLACE PROCEDURE LIONS_DB.DOMAIN.PRC_LOAD_DIM_CLUB()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
DECLARE
    ROW_COUNT_UPSERTED INTEGER;
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Started DIM_CLUB load', 'PRC_LOAD_DIM_CLUB');

    MERGE INTO LIONS_DB.DOMAIN.DIM_CLUB AS target
    USING LIONS_DB.ODS.ODS_CLUBS AS source
    ON target.TM_CLUB_ID = source.CLUB_ID
    WHEN MATCHED AND target.DW_INSERT_TS < source.DW_UPDATE_TS THEN
        UPDATE SET
            CLUB_NAME = source.CLUB_NAME,
            STADIUM_NAME = source.STADIUM_NAME
    WHEN NOT MATCHED THEN
        INSERT (TM_CLUB_ID, CLUB_NAME, STADIUM_NAME)
        VALUES (source.CLUB_ID, source.CLUB_NAME, source.STADIUM_NAME);

    ROW_COUNT_UPSERTED := SQLROWCOUNT;
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Completed DIM_CLUB load. Rows: ' || :ROW_COUNT_UPSERTED, 'PRC_LOAD_DIM_CLUB');

    RETURN 'Success';
END;
$$;
