-- =============================================================================
-- PRC_MERGE_PLAYERS
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE PRC_MERGE_PLAYERS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO ODS_PLAYERS target
    USING VW_ODS_PLAYERS source
    ON target.PLAYER_ID = source.PLAYER_ID
    WHEN MATCHED AND target.MD5_HASH != source.NEW_MD5_HASH THEN
        UPDATE SET
            POSITION = source.POSITION,
            CURRENT_CLUB_ID = source.CURRENT_CLUB_ID,
            MARKET_VALUE_IN_EUR = source.MARKET_VALUE_IN_EUR,
            MD5_HASH = source.NEW_MD5_HASH,
            DW_UPDATE_TS = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED THEN
        INSERT (PLAYER_ID, FIRST_NAME, LAST_NAME, NAME, DATE_OF_BIRTH, POSITION, FOOT, HEIGHT_IN_CM, PLAYER_CODE, CURRENT_CLUB_ID, MARKET_VALUE_IN_EUR, MD5_HASH)
        VALUES (source.PLAYER_ID, source.FIRST_NAME, source.LAST_NAME, source.NAME, source.DATE_OF_BIRTH, source.POSITION, source.FOOT, source.HEIGHT_IN_CM, source.PLAYER_CODE, source.CURRENT_CLUB_ID, source.MARKET_VALUE_IN_EUR, source.NEW_MD5_HASH);

    RETURN 'ODS_PLAYERS merged successfully';
END;
$$;
