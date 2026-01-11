{% macro unnest_key(column_name, key_value) %}
    -- This macro searches the 'event_params' array for a specific key and extracts the value associated with it as a STRING.
    
    (
        select 
            coalesce(
                value.string_value, 
                cast(value.int_value as string), 
                cast(value.float_value as string), 
                cast(value.double_value as string)
            )
        from unnest({{ column_name }}) 
        where key = '{{ key_value }}'
    )
{% endmacro %}