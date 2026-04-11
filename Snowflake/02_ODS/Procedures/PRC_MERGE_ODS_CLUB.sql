-- =============================================================================
-- PRC_MERGE_ODS_CLUB
-- =============================================================================
-- Purpose:    Idempotent merge of Club master data into ODS
-- Standards:  TechTrend logging, ARRAY_CONSTRUCT MD5, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE LIONS_DB.ODS.PRC_MERGE_ODS_CLUB()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
DECLARE
    ROW_COUNT_UPSERTED INTEGER;
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Started ODS_CLUB merge', 'PRC_MERGE_ODS_CLUB');

    MERGE INTO LIONS_DB.ODS.ODS_CLUBS AS TGT
    USING (
        SELECT
            *,
            MD5(TO_VARCHAR(ARRAY_CONSTRUCT(
                CLUB_NAME,
                STADIUM_NAME,
                MARKET_VALUE_CLEAN
            ))) AS NEW_MD5_HASH
        FROM LIONS_DB.ODS.VW_ODS_CLUBS
    ) AS SRC ON TGT.CLUB_ID = SRC.CLUB_ID
    WHEN MATCHED AND TGT.MD5_HASH != SRC.NEW_MD5_HASH THEN
        UPDATE SET
            TOTAL_MARKET_VALUE_EUR = SRC.MARKET_VALUE_CLEAN,
            STADIUM_NAME = SRC.STADIUM_NAME,
            MD5_HASH = SRC.NEW_MD5_HASH,
            DW_UPDATE_TS = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED THEN
        INSERT (
            CLUB_ID, CLUB_NAME, CLUB_CODE, DOMESTIC_COMPETITION_ID,
            TOTAL_MARKET_VALUE_EUR, STADIUM_NAME, MD5_HASH, DW_INSERT_TS
        )
        VALUES (
            SRC.CLUB_ID, SRC.CLUB_NAME, SRC.CLUB_CODE, SRC.DOMESTIC_COMPETITION_ID,
            SRC.MARKET_VALUE_CLEAN, SRC.STADIUM_NAME, SRC.NEW_MD5_HASH, CURRENT_TIMESTAMP()
        );

    ROW_COUNT_UPSERTED := SQLROWCOUNT;
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Completed ODS_CLUB merge. Rows: ' || :ROW_COUNT_UPSERTED, 'PRC_MERGE_ODS_CLUB');

    RETURN 'Success';
END;
$$;
