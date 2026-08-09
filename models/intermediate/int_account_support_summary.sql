select
    account_id,
    count(*) as ticket_count,
    sum(
        case
            when escalation_flag then 1
            else 0
        end
    ) as escalated_ticket_count,
    sum(
        case
            when closed_at is null then 1
            else 0
        end
    ) as open_ticket_count,
    avg(resolution_time_hours) as average_resolution_time_hours,
    avg(first_response_time_minutes) as average_first_response_time_minutes,
    avg(satisfaction_score) as average_satisfaction_score,
    max(submitted_at) as latest_ticket_date
from {{ ref('stg_ravenstack__support_tickets') }}
group by account_id