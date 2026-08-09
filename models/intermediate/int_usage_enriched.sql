select
    u.usage_id,
    u.subscription_id,
    s.account_id,
    u.usage_date,
    u.feature_name,
    u.usage_count,
    u.usage_duration_secs,
    u.error_count,
    u.is_beta_feature,
    s.plan_tier,
    s.start_date as subscription_start_date,
    s.end_date as subscription_end_date
from {{ ref('stg_ravenstack__feature_usage') }} as u
left join {{ ref('int_subscription_enriched') }} as s
    on u.subscription_id = s.subscription_id