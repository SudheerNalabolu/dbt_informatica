with source as (
    select * from {{ source('znawwrkdb', 'WRK_IFRS_QTR_INCR_PAID') }}
)
select
    *
from source
