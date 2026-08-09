select
    s.subscription_id,
    s.account_id,
    s.start_date,
    s.end_date,
    s.plan_tier,
    s.seats,
    s.mrr_amount,
    s.arr_amount,
    s.is_trial,
    s.upgrade_flag,
    s.downgrade_flag,
    s.churn_flag,
    s.billing_frequency,
    s.auto_renew_flag,
    a.account_name,
    a.industry,
    a.country,
    a.signup_date,
    a.referral_source
from {{ ref('stg_ravenstack__subscriptions') }} as s
left join {{ ref('stg_ravenstack__accounts') }} as a
    on s.account_id = a.account_id