{# macros/prm.sql #}

{% macro prm(name, default=None, scope='GLOBAL') %}
  {# 1) dbt job vars override #}
  {% set v = var(name, none) %}
  {% if v is not none %}
    {{ return(v) }}
  {% endif %}

  {# 2) config table #}
  {% set cfg = get_config_param(name, scope, none) %}
  {% if cfg is not none %}
    {{ return(cfg) }}
  {% endif %}

  {# 3) env vars (dbt Cloud) #}
  {% set ev = env_var('DBT_'~name, none) %}
  {% if ev is not none %}
    {{ return(ev) }}
  {% endif %}

  {# 4) fallback #}
  {{ return(default) }}
{% endmacro %}
