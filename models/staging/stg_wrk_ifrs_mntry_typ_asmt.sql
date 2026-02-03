with source as (
    select * from {{ source('znawwrkdb', 'WRK_IFRS_MNTRY_TYP_ASMT') }}
)
select
    *
from source
