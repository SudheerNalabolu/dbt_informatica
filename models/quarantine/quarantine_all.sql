{{ config(
    materialized='incremental'
) }}

-- SETTINGS
{% set audit_schema = 'public_dbt_test__audit' %}
{% set audit_db     = 'DBT_PRACTICE_DB' %}

-- get all failure relations (no pattern -> all failures)
{% set rels = get_test_failure_relations(audit_db=audit_db, audit_schema=audit_schema) %}

{# If there are no failure relations, create an empty target with consistent schema #}
{% if rels | length == 0 %}
select
  null::string     as failure_table,
  null::string     as model_name,
  null::string     as test_name,
  null::timestamp_ntz as quarantined_at,
  null::variant    as row_payload,
  null::string     as row_hash
where 1=0

{% else %}

-- Build the "source" union of all failure tables:
with failures_union as (

  {% for r in rels %}
    select
      '{{ r.identifier }}' as failure_table,
      case
        when split_part('{{ r.identifier }}','__',3) <> '' then split_part('{{ r.identifier }}','__',2)
        when split_part('{{ r.identifier }}','__',2) <> '' then split_part('{{ r.identifier }}','__',1)
        else '{{ r.identifier }}'
      end as model_name,
      -- try to extract a test_name from the table_name if it follows dbt naming; keep as-is otherwise
      case
        when split_part('{{ r.identifier }}','__',3) <> '' then split_part('{{ r.identifier }}','__',3)
        when split_part('{{ r.identifier }}','__',2) <> '' then split_part('{{ r.identifier }}','__',2)
        else null
      end as test_name,
      current_timestamp() as quarantined_at,
      object_construct(*) as row_payload,
      md5(to_json(object_construct(*))) as row_hash
    from {{ r }}
    {% if not loop.last %} union all {% endif %}
  {% endfor %}

)

select
  failure_table,
  model_name,
  test_name,
  quarantined_at,
  row_payload,
  row_hash
from failures_union

{% endif %}

{# ---------- incremental anti-duplication ---------- #}
{% if is_incremental() %}

-- Only insert rows that are not already present (anti-join on row_hash)
select f.*
from (
  {% set rels_inc = get_test_failure_relations(audit_db=audit_db, audit_schema=audit_schema) %}
  {% if rels_inc | length == 0 %}
    select
      null::string     as failure_table,
      null::string     as model_name,
      null::string     as test_name,
      null::timestamp_ntz as quarantined_at,
      null::variant    as row_payload,
      null::string     as row_hash
    where 1=0
  {% else %}
    {% for r in rels_inc %}
      select
        '{{ r.identifier }}' as failure_table,
        case
          when split_part('{{ r.identifier }}','__',3) <> '' then split_part('{{ r.identifier }}','__',2)
          when split_part('{{ r.identifier }}','__',2) <> '' then split_part('{{ r.identifier }}','__',1)
          else '{{ r.identifier }}'
        end as model_name,
        case
          when split_part('{{ r.identifier }}','__',3) <> '' then split_part('{{ r.identifier }}','__',3)
          when split_part('{{ r.identifier }}','__',2) <> '' then split_part('{{ r.identifier }}','__',2)
          else null
        end as test_name,
        current_timestamp() as quarantined_at,
        object_construct(*) as row_payload,
        md5(to_json(object_construct(*))) as row_hash
      from {{ r }}
      {% if not loop.last %} union all {% endif %}
    {% endfor %}
  {% endif %}
) f
left join {{ this }} t
  on f.row_hash = t.row_hash
where t.row_hash is null

{% endif %}