-- =============================================================================
-- VW_ODS_APPEARANCES
-- =============================================================================
-- Purpose:    Deduplicated view of match appearances from Staging stream
-- MD5:        Computed against goals, assists, minutes, and cards
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE VIEW VW_ODS_APPEARANCES AS
SELECT
    APPEARANCE_ID,
    GAME_ID,
    PLAYER_ID,
    PLAYER_CLUB_ID AS CLUB_ID,
    DATE AS MATCH_DATE,
    MINUTES_PLAYED,
    GOALS,
    ASSISTS,
    YELLOW_CARDS,
    RED_CARDS,
    MD5(
        COALESCE(CAST(GOALS AS VARCHAR), '0')
        || COALESCE(CAST(ASSISTS AS VARCHAR), '0')
        || COALESCE(CAST(MINUTES_PLAYED AS VARCHAR), '0')
        || COALESCE(CAST(YELLOW_CARDS AS VARCHAR), '0')
        || COALESCE(CAST(RED_CARDS AS VARCHAR), '0')
    ) AS NEW_MD5_HASH
FROM LIONS_DB.STAGING.STRM_TM_APPEARANCES
QUALIFY ROW_NUMBER() OVER (PARTITION BY APPEARANCE_ID ORDER BY METADATA$TS DESC) = 1;
