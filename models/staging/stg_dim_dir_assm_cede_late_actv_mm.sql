with source as (
    select * from {{ source('zeadimdb', 'DIM_DIR_ASSM_CEDE_LATE_ACTV_MM') }}
)
select
    *
from source
