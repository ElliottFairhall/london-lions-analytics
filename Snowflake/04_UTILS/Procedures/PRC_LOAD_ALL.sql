-- =============================================================================
-- PRC_LOAD_ALL
-- =============================================================================
-- Purpose:    Master orchestration procedure for the London Lions platform
-- =============================================================================

USE SCHEMA LIONS_DB.UTILS;

CREATE OR REPLACE PROCEDURE PRC_LOAD_ALL()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    -- 1. ODS Layer (Deduplicated Stream processing)
    CALL LIONS_DB.ODS.PRC_MERGE_CLUBS();
    CALL LIONS_DB.ODS.PRC_MERGE_PLAYERS();
    CALL LIONS_DB.ODS.PRC_MERGE_APPEARANCES();
    CALL LIONS_DB.ODS.PRC_MERGE_VALUATIONS();

    -- 2. Domain Layer - Dimensions (SCD processing)
    CALL LIONS_DB.DOMAIN.PRC_LOAD_DIM_CLUB();
    CALL LIONS_DB.DOMAIN.PRC_LOAD_DIM_PLAYER();

    -- 3. Domain Layer - Facts (Analytical Aggregations)
    CALL LIONS_DB.DOMAIN.PRC_LOAD_FCT_VALUATIONS();
    CALL LIONS_DB.DOMAIN.PRC_LOAD_FCT_PERFORMANCE();

    -- 4. Ingestion Log
    INSERT INTO LIONS_DB.UTILS.INGESTION_LOG (LOG_MESSAGE)
    VALUES ('Full London Lions Pipeline executed successfully: ODS and Domain layers refreshed');

    RETURN 'London Lions Data Platform Load Complete';
END;
$$;
