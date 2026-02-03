with source as (
    select * from {{ source('zeadimdb', 'DIM_FINC_MNTRY_TYP_MM') }}
)
select
    *
from source
