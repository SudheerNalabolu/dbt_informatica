with source as (
    select * from {{ source('znawwrkdb', 'WRK_ACTU_CL_YLD_CURVE') }}
)
select
    *
from source
