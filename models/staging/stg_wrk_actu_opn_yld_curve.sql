with source as (
    select * from {{ source('znawwrkdb', 'WRK_ACTU_OPN_YLD_CURVE') }}
)
select
    *
from source
