select
    account_id,
    date_trunc('month', usage_date)::date as usage_month,
    count(*) as usage_observation_count,
    count(distinct usage_date) as active_usage_days,
    count(distinct feature_name) as features_used,
    sum(usage_count) as total_usage_count,
    sum(usage_duration_secs) as total_usage_duration_secs,
    sum(error_count) as total_error_count,
    sum(
        case
            when is_beta_feature then 1
            else 0
        end
    ) as beta_usage_observation_count
from {{ ref('int_usage_enriched') }}
group by
    account_id,
    date_trunc('month', usage_date)::date