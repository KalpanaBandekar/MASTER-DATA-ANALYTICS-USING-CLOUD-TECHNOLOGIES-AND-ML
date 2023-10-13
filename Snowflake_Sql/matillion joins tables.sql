Create SCHEMA Joins_Operation;

----- CREATING FIRST TABLE : CUSTOMERNEW---

create or replace table customernew as select * from
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;


select * from customernew;

------- CREATING SECOND TABLE : ORDERNEW 

create or replace table ordernew as select * from
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

select * from ordernew;


--- CREATING OUTPUT TABLE : mastertable

create or replace table mastertable
(
CUSTOMER_KEY NUMBER(38),
CUSTOMER_NAME VARCHAR(200),
CUSTOMER_ADDRESS VARCHAR(200),
ORDER_KEY VARCHAR(200),
ORDER_STATUS VARCHAR(10)
);

select * from mastertable;
