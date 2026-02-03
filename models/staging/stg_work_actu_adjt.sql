with source as (
    select * from {{ source('znawwrkdb', 'WORK_ACTU_ADJT') }}
)
select
    *
from source
