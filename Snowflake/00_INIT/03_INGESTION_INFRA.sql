-- =============================================================================
-- 03_INGESTION_INFRA
-- =============================================================================
-- Purpose:    Configure External Access for Kaggle API Ingestion
-- Note:       ACCOUNTADMIN role is required for these specific objects.
-- =============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE LIONS_DB;
USE SCHEMA STAGING;

-- 1. Create Network Rule for Kaggle API
CREATE OR REPLACE NETWORK RULE KAGGLE_API_NETWORK_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('www.kaggle.com', 'api.kaggle.com', 'storage.googleapis.com')
  COMMENT = 'Allow outbound traffic to Kaggle API and GCS storage';

-- 2. Create Secret for Kaggle Credentials (Placeholder)
-- Usage: User must population this as per README instructions.
CREATE OR REPLACE SECRET KAGGLE_API_CREDENTIALS
  TYPE = GENERIC_STRING
  SECRET_STRING = '{"username":"PLACEHOLDER","key":"PLACEHOLDER"}'
  COMMENT = 'Kaggle API username and key for player data ingestion';

-- 3. Create External Access Integration
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION KAGGLE_EXTERNAL_ACCESS_INT
  ALLOWED_NETWORK_RULES = (KAGGLE_API_NETWORK_RULE)
  ALLOWED_AUTHENTICATION_SECRETS = (KAGGLE_API_CREDENTIALS)
  ENABLED = TRUE
  COMMENT = 'Integration for Python SP to download Transfermarkt data';

-- 4. Grant access to LIONS_ADMIN
GRANT USAGE ON INTEGRATION KAGGLE_EXTERNAL_ACCESS_INT TO ROLE LIONS_ADMIN;
GRANT READ ON SECRET KAGGLE_API_CREDENTIALS TO ROLE LIONS_ADMIN;

USE ROLE LIONS_ADMIN;
