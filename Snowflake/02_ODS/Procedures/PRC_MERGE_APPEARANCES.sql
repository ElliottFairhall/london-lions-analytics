-- =============================================================================
-- PRC_MERGE_APPEARANCES
-- =============================================================================
-- Purpose:    Idempotent merge of match appearance data into ODS
-- MD5:        Uses hash comparison to avoid unnecessary updates
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE PRC_MERGE_APPEARANCES()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO ODS_APPEARANCES target
    USING VW_ODS_APPEARANCES source
    ON target.APPEARANCE_ID = source.APPEARANCE_ID
    WHEN MATCHED AND target.MD5_HASH != source.NEW_MD5_HASH THEN
        UPDATE SET
            MINUTES_PLAYED  = source.MINUTES_PLAYED,
            GOALS           = source.GOALS,
            ASSISTS         = source.ASSISTS,
            YELLOW_CARDS    = source.YELLOW_CARDS,
            RED_CARDS       = source.RED_CARDS,
            MD5_HASH        = source.NEW_MD5_HASH
    WHEN NOT MATCHED THEN
        INSERT (
            APPEARANCE_ID, GAME_ID, PLAYER_ID, CLUB_ID, MATCH_DATE,
            MINUTES_PLAYED, GOALS, ASSISTS, YELLOW_CARDS, RED_CARDS, MD5_HASH
        )
        VALUES (
            source.APPEARANCE_ID, source.GAME_ID, source.PLAYER_ID, source.CLUB_ID, source.MATCH_DATE,
            source.MINUTES_PLAYED, source.GOALS, source.ASSISTS, source.YELLOW_CARDS, source.RED_CARDS, source.NEW_MD5_HASH
        );

    RETURN 'ODS_APPEARANCES merged successfully using MD5 hashing';
END;
$$;
