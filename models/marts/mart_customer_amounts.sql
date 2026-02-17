-- Compile-time pattern (for config used in config() or to generate SQL at compile time)

{% set ml_period = get_dbt_param('ML_FINC_PRD', '197001') %}

{{ config(materialized='incremental', unique_key='CUSTOMER_ID') }}

select
  CUSTOMER_ID,
  total_amount,
  '{{ ml_period }}' as ml_finc_prd
from {{ ref('int_customer_amounts') }}
{% if is_incremental() %}
  where load_ts >= dateadd(month, -10, current_timestamp())
{% endif %}
