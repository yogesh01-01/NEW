
{% macro r_space(column_name) %}
    replace(trim({{ column_name }}), ' ', '')
{% endmacro %}
