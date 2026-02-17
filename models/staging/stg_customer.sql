--Runtime join pattern (recommended for filter values; no compile-time dependency)

with cfg as (
  select PARAMETER_NAME, PARAMETER_VALUE
  from {{ source('config', 'dbt_config_param') }}
  WHERE SCOPE = 'WORK_FLOW_1' 
),

src as (
  select *
  from {{ source('config', 'customers') }}
  where TO_CHAR(business_date, 'YYYYMM') = (
            select PARAMETER_VALUE from cfg where PARAMETER_NAME = 'ML_FINC_PRD'
            )
)

select * from src
