-- =============================================================================
-- VW_ODS_PLAYERS
-- =============================================================================

USE SCHEMA LIONS_DB.ODS;

CREATE OR REPLACE VIEW VW_ODS_PLAYERS AS
SELECT
    PLAYER_ID,
    FIRST_NAME,
    LAST_NAME,
    NAME,
    DATE_OF_BIRTH,
    POSITION,
    FOOT,
    HEIGHT_IN_CM,
    PLAYER_CODE,
    CURRENT_CLUB_ID,
    MARKET_VALUE_IN_EUR,
    MD5(
        COALESCE(POSITION, '')
        || COALESCE(CAST(CURRENT_CLUB_ID AS VARCHAR), '')
        || COALESCE(CAST(MARKET_VALUE_IN_EUR AS VARCHAR), '')
    ) AS NEW_MD5_HASH
FROM LIONS_DB.STAGING.STRM_TM_PLAYERS
QUALIFY ROW_NUMBER() OVER (PARTITION BY PLAYER_ID ORDER BY METADATA$TS DESC) = 1;
