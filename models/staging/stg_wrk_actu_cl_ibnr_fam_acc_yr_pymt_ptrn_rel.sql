with source as (
    select * from {{ source('znawwrkdb', 'WRK_ACTU_CL_IBNR_FAM_ACC_YR_PYMT_PTRN_REL') }}
)
select
    *
from source
