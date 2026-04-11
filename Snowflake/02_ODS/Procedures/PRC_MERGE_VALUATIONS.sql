-- =============================================================================
-- PRC_MERGE_VALUATIONS
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE PRC_MERGE_VALUATIONS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO ODS_VALUATIONS target
    USING VW_ODS_VALUATIONS source
    ON target.VALUATION_ID = source.VALUATION_ID
    WHEN MATCHED AND target.MD5_HASH != source.NEW_MD5_HASH THEN
        UPDATE SET
            MARKET_VALUE_EUR = source.MARKET_VALUE_EUR,
            MD5_HASH = source.NEW_MD5_HASH
    WHEN NOT MATCHED THEN
        INSERT (VALUATION_ID, PLAYER_ID, VALUATION_DATE, MARKET_VALUE_EUR, MD5_HASH)
        VALUES (source.VALUATION_ID, source.PLAYER_ID, source.VALUATION_DATE, source.MARKET_VALUE_EUR, source.NEW_MD5_HASH);

    RETURN 'ODS_VALUATIONS merged successfully using MD5 hashing';
END;
$$;
