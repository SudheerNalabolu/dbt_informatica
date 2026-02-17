select *
  from {{ source('config', 'customer_type') }}