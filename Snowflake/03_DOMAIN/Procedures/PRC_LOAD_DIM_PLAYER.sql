-- =============================================================================
-- PRC_LOAD_DIM_PLAYER
-- =============================================================================
-- Purpose:    Slowly Changing Dimension (Type 2) load for Players
-- Standards:  TechTrend logging, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.DOMAIN;

CREATE OR REPLACE PROCEDURE LIONS_DB.DOMAIN.PRC_LOAD_DIM_PLAYER()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
DECLARE
    ROW_COUNT_EXPIRED INTEGER;
    ROW_COUNT_INSERTED INTEGER;
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Started DIM_PLAYER SCD2 load', 'PRC_LOAD_DIM_PLAYER');

    -- 1. EXPIRE records that have changed
    UPDATE LIONS_DB.DOMAIN.DIM_PLAYER AS target
    SET EFFECTIVE_TO = CURRENT_TIMESTAMP(),
        IS_CURRENT = FALSE
    FROM LIONS_DB.ODS.ODS_PLAYERS AS source
    WHERE target.TM_PLAYER_ID = source.PLAYER_ID
      AND target.IS_CURRENT = TRUE
      AND target.MD5_HASH != source.MD5_HASH;

    ROW_COUNT_EXPIRED := SQLROWCOUNT;

    -- 2. INSERT new records for changed or new players
    INSERT INTO LIONS_DB.DOMAIN.DIM_PLAYER (
        TM_PLAYER_ID, PLAYER_NAME, POSITION, CURRENT_CLUB_NAME,
        MARKET_VALUE_EUR, MD5_HASH, EFFECTIVE_FROM, EFFECTIVE_TO, IS_CURRENT
    )
    SELECT
        s.PLAYER_ID,
        s.NAME,
        s.POSITION,
        COALESCE(c.CLUB_NAME, 'Unknown'),
        s.MARKET_VALUE_IN_EUR,
        s.MD5_HASH,
        CURRENT_TIMESTAMP(),
        '9999-12-31'::TIMESTAMP_NTZ,
        TRUE
    FROM LIONS_DB.ODS.ODS_PLAYERS s
    LEFT JOIN LIONS_DB.ODS.ODS_CLUBS c ON s.CURRENT_CLUB_ID = c.CLUB_ID
    LEFT JOIN LIONS_DB.DOMAIN.DIM_PLAYER current_dim
      ON s.PLAYER_ID = current_dim.TM_PLAYER_ID AND current_dim.IS_CURRENT = TRUE
    WHERE current_dim.TM_PLAYER_ID IS NULL;

    ROW_COUNT_INSERTED := SQLROWCOUNT;

    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Completed DIM_PLAYER SCD2 load. Expired: ' || :ROW_COUNT_EXPIRED || ', Inserted: ' || :ROW_COUNT_INSERTED, 'PRC_LOAD_DIM_PLAYER');

    RETURN 'Success';
END;
$$;
