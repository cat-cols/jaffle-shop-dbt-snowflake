{% set temperature = 80.0 %}

On a day like this, I especially like
{% if temperature >75 %}
    a refreshing sorbet
{% else %}
    a warm cup of coffee
{% endif %}


{% if temperature > 75 %}
    {% set weather = "hot" %}
{% else %}
    {% set weather = "cold" %}
{% endif %}

SELECT {{ temperature }} as temperature, '{{ weather }}' as weather