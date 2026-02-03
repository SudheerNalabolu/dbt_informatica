with source as (
    select * from {{ source('zeadimdb', 'DIM_CRCY_LATE_ACTV_MM') }}
)
select
    *
from source
