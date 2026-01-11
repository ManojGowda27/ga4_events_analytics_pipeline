with session_metrics as (
    select * from {{ ref('int_sessions__aggregated') }}
)

select
    session_id,
    user_id,
    session_date,
    session_start_timestamp,
    
    -- Business Logic: What counts as a bounce?
    -- If they viewed 1 page and spent 0 minutes, it's a bounce.
    case 
        when session_duration_minutes = 0 and page_views = 1 then true 
        else false 
    end as is_bounce,
    
    session_duration_minutes,
    page_views,
    purchase_count,
    
    -- Unnesting the struct we created in the intermediate layer
    session_source.traffic_source,
    session_source.medium,
    session_source.campaign

from session_metrics