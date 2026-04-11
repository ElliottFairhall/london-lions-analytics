-- =============================================================================
-- PRC_MERGE_ODS_PLAYER
-- =============================================================================
-- Purpose:    Idempotent merge of Player master data into ODS
-- Standards:  TechTrend logging, ARRAY_CONSTRUCT MD5, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE LIONS_DB.ODS.PRC_MERGE_ODS_PLAYER()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
DECLARE
    ROW_COUNT_UPSERTED INTEGER;
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Started ODS_PLAYER merge', 'PRC_MERGE_ODS_PLAYER');

    MERGE INTO LIONS_DB.ODS.ODS_PLAYERS AS TGT
    USING (
        SELECT
            *,
            MD5(TO_VARCHAR(ARRAY_CONSTRUCT(
                POSITION,
                CURRENT_CLUB_ID,
                MARKET_VALUE_IN_EUR
            ))) AS NEW_MD5_HASH
        FROM LIONS_DB.ODS.VW_ODS_PLAYERS
    ) AS SRC ON TGT.PLAYER_ID = SRC.PLAYER_ID
    WHEN MATCHED AND TGT.MD5_HASH != SRC.NEW_MD5_HASH THEN
        UPDATE SET
            POSITION = SRC.POSITION,
            CURRENT_CLUB_ID = SRC.CURRENT_CLUB_ID,
            MARKET_VALUE_IN_EUR = SRC.MARKET_VALUE_IN_EUR,
            MD5_HASH = SRC.NEW_MD5_HASH,
            DW_UPDATE_TS = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED THEN
        INSERT (
            PLAYER_ID, FIRST_NAME, LAST_NAME, NAME, DATE_OF_BIRTH,
            POSITION, FOOT, HEIGHT_IN_CM, PLAYER_CODE,
            CURRENT_CLUB_ID, MARKET_VALUE_IN_EUR, MD5_HASH, DW_INSERT_TS
        )
        VALUES (
            SRC.PLAYER_ID, SRC.FIRST_NAME, SRC.LAST_NAME, SRC.NAME, SRC.DATE_OF_BIRTH,
            SRC.POSITION, SRC.FOOT, SRC.HEIGHT_IN_CM, SRC.PLAYER_CODE,
            SRC.CURRENT_CLUB_ID, SRC.MARKET_VALUE_IN_EUR, SRC.NEW_MD5_HASH, CURRENT_TIMESTAMP()
        );

    ROW_COUNT_UPSERTED := SQLROWCOUNT;
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Completed ODS_PLAYER merge. Rows: ' || :ROW_COUNT_UPSERTED, 'PRC_MERGE_ODS_PLAYER');

    RETURN 'Success';
END;
$$;
