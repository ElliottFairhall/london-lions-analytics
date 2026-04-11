-- =============================================================================
-- 02_TEARDOWN_ENV
-- =============================================================================
-- Purpose:    Decommission LIONS_DB and associated objects
-- Author:     London Lions Analytics
-- =============================================================================

USE ROLE ACCOUNTADMIN;

DROP DATABASE IF EXISTS LIONS_DB;
DROP WAREHOUSE IF EXISTS LIONS_WH;
DROP ROLE IF EXISTS LIONS_ADMIN;

-- Note: Drops cascade to all schemas, tables, views, and procedures.
