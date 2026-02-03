with source as (
    select * from {{ source('znawwrkdb', 'FACT_ACTU_ADJT_ACCUM_MM') }}
)
select
    *
from source
