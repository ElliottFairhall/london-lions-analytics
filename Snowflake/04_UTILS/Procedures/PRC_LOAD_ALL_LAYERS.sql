-- =============================================================================
-- PRC_LOAD_ALL_LAYERS
-- =============================================================================
-- Purpose:    Master orchestration procedure for the London Lions platform
-- Standards:  TechTrend logging, Explicit DB prefixing
-- =============================================================================

USE SCHEMA LIONS_DB.UTILS;

CREATE OR REPLACE PROCEDURE LIONS_DB.UTILS.PRC_LOAD_ALL_LAYERS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER AS
$$
BEGIN
    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'Starting London Lions Full Pipeline', 'PRC_LOAD_ALL_LAYERS');

    -- 1. ODS Layer (Deduplicated Stream processing)
    CALL LIONS_DB.ODS.PRC_MERGE_ODS_CLUB();
    CALL LIONS_DB.ODS.PRC_MERGE_ODS_PLAYER();
    CALL LIONS_DB.ODS.PRC_MERGE_ODS_APPEARANCE();
    CALL LIONS_DB.ODS.PRC_MERGE_ODS_VALUATION();

    -- 2. Domain Layer - Dimensions (SCD processing)
    CALL LIONS_DB.DOMAIN.PRC_LOAD_DIM_CLUB();
    CALL LIONS_DB.DOMAIN.PRC_LOAD_DIM_PLAYER();

    -- 3. Domain Layer - Facts (Analytical Aggregations)
    CALL LIONS_DB.DOMAIN.PRC_LOAD_FCT_VALUATIONS();
    CALL LIONS_DB.DOMAIN.PRC_LOAD_FCT_PERFORMANCE();

    CALL LIONS_DB.UTILS.UTL_LOG_EVENT('INFO', 'London Lions Full Pipeline Completed successfully', 'PRC_LOAD_ALL_LAYERS');

    RETURN 'Success';
EXCEPTION
    WHEN OTHER THEN
        CALL LIONS_DB.UTILS.UTL_LOG_EVENT('ERROR', 'Pipeline Failure: ' || SQLERRM, 'PRC_LOAD_ALL_LAYERS');
        RAISE;
END;
$$;
