{{ config(materialized='table') }}

WITH raw_customer_ref AS (

    SELECT * FROM {{ ref('stg_customer_ref') }}

),

clean_rows AS (

    {{ quarantine_from_schema(
        model_name       = 'ref_int_customer',
        source_cte       = 'raw_customer_ref',
        quarantine_table = target.schema ~ '.ref_int_customer__quarantine',
        schema_tests     = generate_quarantine_rules('ref_int_customer')
    ) }}

)

SELECT * FROM clean_rows