-- =============================================================================
-- PRC_MERGE_ODS_VALUATION
-- =============================================================================
-- Purpose:    Idempotent merge of Player Valuation data into ODS
-- Standards:  TechTrend logging, ARRAY_CONSTRUCT MD5, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE LIONS_DB.ODS.PRC_MERGE_ODS_VALUATION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
DECLARE
    ROW_COUNT_UPSERTED INTEGER;
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Started ODS_VALUATION merge', 'PRC_MERGE_ODS_VALUATION');

    MERGE INTO LIONS_DB.ODS.ODS_VALUATIONS AS TGT
    USING (
        SELECT
            *,
            MD5(TO_VARCHAR(ARRAY_CONSTRUCT(
                MARKET_VALUE_EUR
            ))) AS NEW_MD5_HASH
        FROM LIONS_DB.ODS.VW_ODS_VALUATIONS
    ) AS SRC ON TGT.VALUATION_ID = SRC.VALUATION_ID
    WHEN MATCHED AND TGT.MD5_HASH != SRC.NEW_MD5_HASH THEN
        UPDATE SET
            MARKET_VALUE_EUR = SRC.MARKET_VALUE_EUR,
            MD5_HASH = SRC.NEW_MD5_HASH
    WHEN NOT MATCHED THEN
        INSERT (
            VALUATION_ID, PLAYER_ID, VALUATION_DATE, MARKET_VALUE_EUR, MD5_HASH, DW_INSERT_TS
        )
        VALUES (
            SRC.VALUATION_ID, SRC.PLAYER_ID, SRC.VALUATION_DATE, SRC.MARKET_VALUE_EUR, SRC.NEW_MD5_HASH, CURRENT_TIMESTAMP()
        );

    ROW_COUNT_UPSERTED := SQLROWCOUNT;
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Completed ODS_VALUATION merge. Rows: ' || :ROW_COUNT_UPSERTED, 'PRC_MERGE_ODS_VALUATION');

    RETURN 'Success';
END;
$$;
