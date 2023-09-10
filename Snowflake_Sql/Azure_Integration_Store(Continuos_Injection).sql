CREATE OR REPLACE DATABASE AZUREDATABASE;

USE AZUREDATABASE;

DROP TABLE TRANSACTION_RAW;

CREATE OR REPLACE TABLE TRANSACTION_RAW 
(household_key	INT,
BASKET_ID	INT,
DAY	INT,
PRODUCT_ID	INT,
QUANTITY	INT,
SALES_VALUE	FLOAT,
STORE_ID	INT,
RETAIL_DISC	FLOAT,
TRANS_TIME	INT,
WEEK_NO	INT,
COUPON_DISC	INT,
COUPON_MATCH_DISC INT);


create or replace file format RETAIL_TRNXS_CSV 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ','
    field_optionally_enclosed_by = 'none'
    skip_header = 1 ; 



CREATE OR REPLACE NOTIFICATION INTEGRATION RETAIL_TRNXS_INTEGRATION
ENABLED = TRUE
TYPE= QUEUE
NOTIFICATION_PROVIDER= AZURE_STORAGE_QUEUE
AZURE_STORAGE_QUEUE_PRIMARY_URI='https://kbretail.queue.core.windows.net/kbretailqueue'
AZURE_TENANT_ID='0a90bd80-03b1-4962-a76d-9de15c7f6cdd';

SHOW INTEGRATIONS;

DESC NOTIFICATION INTEGRATION RETAIL_TRNXS_INTEGRATION;

---Primary blob service endpoint : https://snowflakesnowpipetesting.blob.core.windows.net/
----blob service sas url : https://snowflakesnowpipetesting.blob.core.windows.net/?sv=2022-11-02&ss=bfqt&srt=co&sp=rwdlacupytfx&se=2023-07-04T20:33:38Z&st=2023-07-04T12:33:38Z&spr=https&sig=wYuWw194d3BFX5P52u2A92NCOZZBLU2SfyyZPcGXzPg%3D


CREATE OR REPLACE STAGE TRANSACTION_STAGE
url = 'azure://kbretail.blob.core.windows.net/kbretailcontainer/'
credentials = (azure_sas_token='?sv=2022-11-02&ss=bfqt&srt=co&sp=rwdlacupiytfx&se=2023-10-07T15:43:08Z&st=2023-09-09T07:43:08Z&spr=https&sig=Humyake4joP%2BQOkDJQDQrlpJ%2FQMZtUaDryxFWB%2FHVeo%3D'
);


SHOW STAGES;

LS @TRANSACTION_STAGE;



CREATE OR REPLACE PIPE "RETAIL_TRANSACTION_PIPE"
  auto_ingest = true
  integration = 'RETAIL_TRNXS_INTEGRATION'
  as
  copy into TRANSACTION_RAW
  from @TRANSACTION_STAGE
  file_format = RETAIL_TRNXS_CSV ;

SELECT COUNT(*) FROM TRANSACTION_RAW;

SELECT * FROM TRANSACTION_RAW ;

SHOW PIPES;
  
  
ALTER PIPE RETAIL_TRANSACTION_PIPE REFRESH;

select *
from table(information_schema.copy_history (table_name=> 'TRANSACTION_RAW', start_time=> dateadd (hours, -1, current_timestamp())));