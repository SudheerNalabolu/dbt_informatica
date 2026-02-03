with source as (
    select * from {{ source('zeadimdb', 'DIM_CLR_HOUS_POL_CATG_LATE_ACTV_MM') }}
)
select
    *
from source
