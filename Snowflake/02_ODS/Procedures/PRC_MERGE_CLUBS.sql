-- =============================================================================
-- PRC_MERGE_CLUBS
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE PRC_MERGE_CLUBS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO ODS_CLUBS target
    USING VW_ODS_CLUBS source
    ON target.CLUB_ID = source.CLUB_ID
    WHEN MATCHED AND target.MD5_HASH != source.NEW_MD5_HASH THEN
        UPDATE SET
            TOTAL_MARKET_VALUE_EUR = source.MARKET_VALUE_CLEAN,
            STADIUM_NAME = source.STADIUM_NAME,
            MD5_HASH = source.NEW_MD5_HASH,
            DW_UPDATE_TS = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED THEN
        INSERT (CLUB_ID, CLUB_NAME, CLUB_CODE, DOMESTIC_COMPETITION_ID, TOTAL_MARKET_VALUE_EUR, STADIUM_NAME, MD5_HASH)
        VALUES (source.CLUB_ID, source.CLUB_NAME, source.CLUB_CODE, source.DOMESTIC_COMPETITION_ID, source.MARKET_VALUE_CLEAN, source.STADIUM_NAME, source.NEW_MD5_HASH);

    RETURN 'ODS_CLUBS merged successfully using MD5 hashing';
END;
$$;
