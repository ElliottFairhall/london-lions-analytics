-- =============================================================================
-- 01_CREATE_ENV
-- =============================================================================
-- Purpose:    Initialize Database, Schemas, and RBAC for London Lions FC
-- Author:     London Lions Analytics
-- UK English: Standardised
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Database Setup
CREATE OR REPLACE DATABASE LIONS_DB
COMMENT = 'Enterprise Data Platform for London Lions Football Club';

-- Schema Setup (Medallion Architecture)
CREATE OR REPLACE SCHEMA LIONS_DB.STAGING COMMENT = 'Raw Landing Area (Transfermarkt)';
CREATE OR REPLACE SCHEMA LIONS_DB.ODS COMMENT = 'Operational Data Store (Deduplicated)';
CREATE OR REPLACE SCHEMA LIONS_DB.DOMAIN COMMENT = 'Analytical Domain (SPV Metrics)';
CREATE OR REPLACE SCHEMA LIONS_DB.UTILS COMMENT = 'Operational Utilities & Logging';
CREATE OR REPLACE SCHEMA LIONS_DB.GOVERNANCE COMMENT = 'Security & Compliance (Masking/RLS)';

-- Virtual Warehouse
CREATE OR REPLACE WAREHOUSE LIONS_WH
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE
COMMENT = 'Computational engine for LIONS_DB';

-- RBAC Foundation
CREATE OR REPLACE ROLE LIONS_ADMIN;
GRANT ROLE LIONS_ADMIN TO ROLE SYSADMIN;

GRANT ALL PRIVILEGES ON DATABASE LIONS_DB TO ROLE LIONS_ADMIN;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE LIONS_DB TO ROLE LIONS_ADMIN;
GRANT ALL PRIVILEGES ON WAREHOUSE LIONS_WH TO ROLE LIONS_ADMIN;

USE ROLE LIONS_ADMIN;
USE WAREHOUSE LIONS_WH;
USE DATABASE LIONS_DB;
