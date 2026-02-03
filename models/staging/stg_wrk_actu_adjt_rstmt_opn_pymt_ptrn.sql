with source as (
    select * from {{ source('znawwrkdb', 'WRK_ACTU_ADJT_RSTMT_OPN_PYMT_PTRN') }}
)
select
    *
from source
