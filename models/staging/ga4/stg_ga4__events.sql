with source as (
    select * from {{ source('ga4', 'events') }}
),

renamed as (
    select
        -- Event identifiers
        event_date,
        event_timestamp,
        event_name,
        
        -- User & Session info
        user_pseudo_id as user_id,
        
        -- UNNESTING: Using our custom macro to extract key fields
        -- We explicitly cast these to ensure BigQuery handles them correctly
       cast({{ unnest_key('event_params', 'ga_session_id') }} as int64) as session_id,
        cast({{ unnest_key('event_params', 'page_location') }} as string) as page_url,
        cast({{ unnest_key('event_params', 'page_title') }} as string) as page_title,
        
        -- Device & Geo info
        device.category as device_category,
        device.mobile_brand_name,
        geo.country,
        
        -- Traffic Source (Where did they come from?)
        traffic_source.name as campaign,
        traffic_source.medium,
        traffic_source.source as traffic_source

    from source
)

select * from renamed