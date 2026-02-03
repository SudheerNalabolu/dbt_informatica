with source as (
    select * from {{ source('zeadimdb', 'DIM_INSR_MM') }}
)
select
    *
from source
