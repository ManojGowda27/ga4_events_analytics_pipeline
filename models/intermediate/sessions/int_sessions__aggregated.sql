with events as (
    select * from {{ ref('stg_ga4__events') }}
    where session_id is not null
),

aggregated as (
    select
        session_id,
        user_id,
        min(event_date) as session_date,
        
        -- Aggregation: Start and End times
        min(event_timestamp) as session_start_timestamp,
        max(event_timestamp) as session_end_timestamp,
        
        -- Calculations: Duration in minutes
        (max(event_timestamp) - min(event_timestamp)) / 60000000 as session_duration_minutes,
        
        -- Counters
        count(event_name) as total_events,
        countif(event_name = 'page_view') as page_views,
        countif(event_name = 'purchase') as purchase_count,
        
        -- Attribution (First Touch logic for the session)
        -- Take the first campaign source seen in the session
        array_agg(
            struct(traffic_source, medium, campaign) 
            order by event_timestamp asc limit 1
        )[offset(0)] as session_source

    from events
    group by 1, 2
)

select * from aggregated