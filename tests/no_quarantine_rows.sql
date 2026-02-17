-- This data test fails if any row exists in the quarantine_all table.
select *
from {{ ref('quarantine_all') }}
limit 1
