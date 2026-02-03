with source as (
    select * from {{ source('znawwrkdb', 'WORK_SRC_SYS_ACTU_BEST_EST_BKD_ALOC') }}
)
select
    *
from source
