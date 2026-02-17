  select *
  from {{ source('config', 'country') }}