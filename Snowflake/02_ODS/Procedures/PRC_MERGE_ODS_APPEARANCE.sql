-- =============================================================================
-- PRC_MERGE_ODS_APPEARANCE
-- =============================================================================
-- Purpose:    Idempotent merge of Match Performance data into ODS
-- Standards:  TechTrend logging, ARRAY_CONSTRUCT MD5, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE PROCEDURE LIONS_DB.ODS.PRC_MERGE_ODS_APPEARANCE()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
DECLARE
    ROW_COUNT_UPSERTED INTEGER;
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Started ODS_APPEARANCE merge', 'PRC_MERGE_ODS_APPEARANCE');

    MERGE INTO LIONS_DB.ODS.ODS_APPEARANCES AS TGT
    USING (
        SELECT
            *,
            MD5(TO_VARCHAR(ARRAY_CONSTRUCT(
                MINUTES_PLAYED,
                GOALS,
                ASSISTS,
                YELLOW_CARDS,
                RED_CARDS
            ))) AS NEW_MD5_HASH
        FROM LIONS_DB.ODS.VW_ODS_APPEARANCES
    ) AS SRC ON TGT.APPEARANCE_ID = SRC.APPEARANCE_ID
    WHEN MATCHED AND TGT.MD5_HASH != SRC.NEW_MD5_HASH THEN
        UPDATE SET
            MINUTES_PLAYED = SRC.MINUTES_PLAYED,
            GOALS = SRC.GOALS,
            ASSISTS = SRC.ASSISTS,
            YELLOW_CARDS = SRC.YELLOW_CARDS,
            RED_CARDS = SRC.RED_CARDS,
            MD5_HASH = SRC.NEW_MD5_HASH
    WHEN NOT MATCHED THEN
        INSERT (
            APPEARANCE_ID, GAME_ID, PLAYER_ID, CLUB_ID, MATCH_DATE,
            MINUTES_PLAYED, GOALS, ASSISTS, YELLOW_CARDS, RED_CARDS, MD5_HASH, DW_INSERT_TS
        )
        VALUES (
            SRC.APPEARANCE_ID, SRC.GAME_ID, SRC.PLAYER_ID, SRC.CLUB_ID, SRC.MATCH_DATE,
            SRC.MINUTES_PLAYED, SRC.GOALS, SRC.ASSISTS, SRC.YELLOW_CARDS, SRC.RED_CARDS, SRC.NEW_MD5_HASH, CURRENT_TIMESTAMP()
        );

    ROW_COUNT_UPSERTED := SQLROWCOUNT;
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Completed ODS_APPEARANCE merge. Rows: ' || :ROW_COUNT_UPSERTED, 'PRC_MERGE_ODS_APPEARANCE');

    RETURN 'Success';
END;
$$;
