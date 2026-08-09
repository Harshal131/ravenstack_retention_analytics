select
    ticket_id,
    account_id,
    cast(submitted_at as date) as submitted_at,
    cast(closed_at as timestamp) as closed_at,
    cast(resolution_time_hours as integer) as resolution_time_hours,
    priority,
    cast(first_response_time_minutes as integer) as first_response_time_minutes,
    cast(satisfaction_score as integer) as satisfaction_score,
    cast(escalation_flag as boolean) as escalation_flag
from {{ ref('ravenstack_support_tickets') }}