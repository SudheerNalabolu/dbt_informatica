-- macros/get_dbt_param.sql

{% macro get_dbt_param(param_name, scope='GLOBAL', default=None) %}
  {# If dbt is only parsing and not executing, return the default #}
  {% if not execute %}
    {{ return(default) }}
  {% endif %}

  {% set sql %}
    select PARAMETER_VALUE
    from PROJ_SHARED.DBT_PARAMS
    where PARAMETER_NAME = '{{ param_name }}'
    limit 1
  {% endset %}

  {% set res = run_query(sql) %}
  {% if res is none %}
    {{ return(default) }}
  {% endif %}

  {# Modern dbt exposes rows via res.rows #}
  {% if res.rows | length == 0 %}
    {{ return(default) }}
  {% endif %}

  {% set val = res.rows[0][0] %}
  {{ return(val) }}
{% endmacro %}
