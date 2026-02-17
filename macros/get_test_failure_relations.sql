{% macro get_test_failure_relations(audit_db=target.database, audit_schema=target.schema ~ '_dbt_test__audit', like_pattern=None) %}
{%- set audit_db = audit_db -%}
{%- set audit_schema = audit_schema -%}

{# Build the information_schema query for Snowflake #}
{% set q %}
select table_name
from "{{ audit_db }}".information_schema.tables
where table_schema = upper('{{ audit_schema }}')
  and table_type = 'BASE TABLE'
  {% if like_pattern %}
    and table_name ilike '{{ like_pattern }}'
  {% endif %}
order by table_name
{% endset %}

{% set results = run_query(q) %}
{% if not execute %}
  {{ return([]) }}
{% endif %}

{% set relations = [] %}
{% for row in results.rows %}
  {% set tbl = row[0] %}
  {# create a Relation object for safe quoting/rendering #}
  {% do relations.append(adapter.get_relation(database=audit_db, schema=audit_schema, identifier=tbl)) %}
{% endfor %}

{{ return(relations) }}
{{ log(relations), info-True }}
{% endmacro %}
