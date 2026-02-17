--Runtime join pattern (recommended for filter values; no compile-time dependency)

with cfg as (
  select PARAMETER_NAME, PARAMETER_VALUE
  from {{ source('config', 'dbt_config_param') }}
  WHERE SCOPE = 'WORK_FLOW_1' 
),

src as (
  select *
  from {{ source('config', 'customers') }}
  --where business_date not in ('2025-08-20' ,'2025-09-07')
)

select * from src
