with source as (
    select * from {{ source('zeadimdb', 'WRK_DIM_IBNR_FAM_ACTU_ADJT') }}
)
select
    *
from source
