-- dbt build --vars '{step_key: "1234"}'
{% macro job_preprocessing(step_key) %}
  {% if not execute %} {{ return('') }} {% endif %}

  {% if step_key is none or step_key|string|length == 0 %}
    {{ exceptions.raise_compiler_error("job_preprocessing: step_key is missing/empty") }}
  {% endif %}

  {% set sql %}
    call DBT_PRACTICE_DB.PROJ_SHARED.SP_LOAD_DBT_PARAMS_BY_STEP_KEY({{ step_key }})
  {% endset %}

  {% do log("Running: " ~ sql, info=True) %}
  {% do run_query(sql) %}
{% endmacro %}