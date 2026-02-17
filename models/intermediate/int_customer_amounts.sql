with cfg as (
  select PARAMETER_NAME, PARAMETER_VALUE
  from {{ source('config', 'dbt_config_param') }}
  WHERE SCOPE = 'WORK_FLOW_1' 
),

params as (
    select
        max(case when PARAMETER_NAME = 'ML_FINC_PRD' then PARAMETER_VALUE end) as ml_finc_prd,
        max(case when PARAMETER_NAME = 'MP_FINC_PRD' then PARAMETER_VALUE end) as mp_finc_prd,
        max(case when PARAMETER_NAME = 'InitialLoadFlag' then PARAMETER_VALUE end) as initial_load_flag
    from cfg
),

base as (
  select CUSTOMER_ID, amount, load_ts
  from {{ ref('stg_customer') }}
)

select
  b.CUSTOMER_ID,
  p.initial_load_flag,
  sum(b.amount) as total_amount,
  max(b.load_ts) as load_ts
from base b
cross join params p
group by CUSTOMER_ID, initial_load_flag
