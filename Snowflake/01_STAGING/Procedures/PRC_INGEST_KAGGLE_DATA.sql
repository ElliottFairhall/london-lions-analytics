-- =============================================================================
-- PRC_INGEST_KAGGLE_DATA
-- =============================================================================
-- Purpose:    Python Stored Procedure to ingest Transfermarkt data from Kaggle
-- Ingestion:  Downloads archive.zip, extracts CSVs, and loads to Staging
-- =============================================================================

USE SCHEMA LIONS_DB.STAGING;

CREATE OR REPLACE PROCEDURE PRC_INGEST_KAGGLE_DATA()
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python', 'requests')
EXTERNAL_ACCESS_INTEGRATIONS = (KAGGLE_EXTERNAL_ACCESS_INT)
SECRETS = ('credentials' = KAGGLE_API_CREDENTIALS)
HANDLER = 'main'
AS
$$
import requests
import zipfile
import io
import pandas as pd
from snowflake.snowpark.files import SnowflakeFile
from _snowflake import get_generic_secret_string

def main(session):
    # 1. Retrieve Credentials from Snowflake Secret
    creds = get_generic_secret_string('credentials')
    import json
    c = json.loads(creds)
    username = c['username']
    password = c['key']

    # 2. Kaggle API Endpoint
    url = "https://www.kaggle.com/api/v1/datasets/download/davidcariboo/player-scores?datasetVersionNumber=652"

    # 3. Download the ZIP file
    response = requests.get(url, auth=(username, password))
    if response.status_code != 200:
        return f"Failed to download: {response.status_code} - {response.text}"

    # 4. Extract CSVs and Load to Staging Tables
    with zipfile.ZipFile(io.BytesIO(response.content)) as z:
        for file_name in z.namelist():
            if file_name.endswith('.csv'):
                table_name = "STG_TM_" + file_name.replace('.csv', '').upper()
                with z.open(file_name) as f:
                    df = pd.read_csv(f)
                    # Convert column names to uppercase for Snowflake
                    df.columns = [c.upper() for c in df.columns]
                    # Write to Snowflake Staging table (Overwrite for simplicity in this demo)
                    session.write_pandas(df, table_name, auto_create_table=True, overwrite=True)

    return "Successfully ingested all Transfermarkt CSVs into LIONS_DB.STAGING"

$$;
