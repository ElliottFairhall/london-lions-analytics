-- =============================================================================
-- 01_MASKING_POLICIES
-- =============================================================================

USE SCHEMA LIONS_DB.GOVERNANCE;

-- Masking for Player Agent Names (Privacy)
CREATE OR REPLACE MASKING POLICY MSK_AGENT_NAME
AS (VAL VARCHAR) RETURNS varchar ->
  CASE
    WHEN CURRENT_ROLE() IN ('LIONS_ADMIN', 'LIONS_DIRECTOR_FOOTBALL') THEN VAL
    ELSE '*** PROPRIETARY ***'
  END;

-- Apply to ODS_PLAYERS (if agent info was there) or DIM_PLAYER
-- Note: Applying to staging for demonstration
-- ALTER TABLE LIONS_DB.STAGING.STG_TM_PLAYERS MODIFY COLUMN AGENT_NAME SET MASKING POLICY MSK_AGENT_NAME;
