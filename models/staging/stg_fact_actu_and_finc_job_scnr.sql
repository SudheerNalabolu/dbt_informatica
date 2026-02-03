with source as (
    select * from {{ source('znawwrkdb', 'ACTU_AND_FINC_JOB_SCNR') }}
)
select
    *
from source
