with source as (
    select * from {{ source('znawwrkdb', 'WRK_ACTU_ADJT_PORT_XFER') }}
)
select
    *
from source
