with source as (
    select * from {{ source('zeadimdb', 'DIM_REINS_AGMT_MM') }}
)
select
    *
from source
