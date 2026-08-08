# RavenStack Retention Analytics

A portfolio analytics engineering project built with **dbt Core** and **DuckDB**.

This project addresses a SaaS retention reporting problem using the RavenStack dataset:

> Which accounts are churning, how much recurring revenue is affected, and what usage or support signals appear before churn?

RavenStack is a fictional SaaS company and the dataset is synthetic. This repository demonstrates how an analytics engineer can turn raw operational data into tested, documented, business-facing datasets.

## Project overview

RavenStack leadership needs a trustworthy view of customer retention. Different teams need to understand:

- which accounts have churned,
- when churn occurred,
- how much recurring revenue was affected,
- whether product usage declined before churn,
- whether support activity was associated with churn,
- and which active accounts may require retention attention.

The project builds a reusable analytics layer for Customer Success, Finance, Product, Support, and Analytics teams.

## Business problem

The company currently lacks a consistent way to connect:

- account information,
- subscription history,
- product usage,
- customer support activity,
- churn events,
- and recurring revenue.

Without a consistent data model, teams may calculate churn differently or fail to identify high-value accounts before they leave.

This project creates documented and tested models that establish consistent definitions for retention and churn analysis.

## Project objective

The objective is to build an analytics-ready retention data layer that helps answer:

1. How many customers are active, retained, or churned?
2. How much recurring revenue was lost through churn?
3. Which plans, segments, or customer groups experience the highest churn?
4. What usage patterns appear before churn?
5. Does support activity appear alongside churn?
6. Which active accounts show indicators that may justify retention outreach?

The initial scope focuses on descriptive and diagnostic analytics. Predictive machine learning is outside the scope of version one.

## Intended users

| User | Decision supported |
|---|---|
| Customer Success | Which accounts should receive retention attention? |
| Finance | How much recurring revenue was lost through churn? |
| Product | Which usage behaviors are associated with retention? |
| Support | Are ticket volume, escalations, or resolution time associated with churn? |
| Analytics | Can retention metrics be reproduced and trusted? |

## Analytical outputs

The project will produce business-facing datasets for the following use cases.

### Account health

One row per account containing:

- account attributes,
- current subscription,
- plan,
- recurring revenue,
- tenure,
- recent product usage,
- support activity,
- churn status,
- retention indicators.

### Subscription lifecycle

Subscription-level and event-level data containing:

- account,
- plan,
- subscription start and end dates,
- subscription status,
- recurring revenue,
- upgrades,
- downgrades,
- cancellations,
- churn events.

### Churn analysis

Churn reporting containing:

- churned accounts,
- churn date,
- plan at the time of churn,
- revenue affected,
- usage before churn,
- support activity before churn,
- churn by plan,
- churn by reporting period.

### Retention health

A prioritized account-level output containing:

- active accounts,
- recent usage decline,
- unresolved support activity,
- high-value accounts,
- churn indicators,
- retention priority groups.

## Dataset

This project uses the [SaaS Subscription & Churn Analytics Dataset](https://www.kaggle.com/datasets/rivalytics/saas-subscription-and-churn-analytics-dataset) from Kaggle.

The dataset represents a fictional SaaS company called RavenStack and includes simulated account, subscription, usage, support, and churn activity.

### Seed files

The current seed files are:

```text
ravenstack_accounts.csv
ravenstack_subscriptions.csv
ravenstack_feature_usage.csv
ravenstack_support_tickets.csv
ravenstack_churn_events.csv
```

These files are loaded into DuckDB using dbt seeds.

### Data limitation

The dataset is synthetic. It is useful for demonstrating data modeling and analytics engineering practices, but it should not be presented as real company data or as evidence of real customer behavior.

The project can identify patterns and associations in the data. It cannot prove that a specific usage or support behavior caused a customer to churn.

## Data architecture

```text
CSV seed files
      |
      v
Raw seed tables
      |
      v
Staging models
  - rename columns
  - cast data types
  - standardize fields
      |
      v
Intermediate models
  - subscription lifecycle
  - usage summaries
  - support summaries
  - churn windows
  - revenue calculations
      |
      v
Business marts
  - account health
  - subscription lifecycle
  - churn analysis
  - retention health
```

## dbt project structure

```text
ravenstack_retention_analytics/
├── analyses/
├── macros/
├── models/
│   ├── staging/
│   │   └── ravenstack/
│   ├── intermediate/
│   │   └── retention/
│   └── marts/
│       └── retention/
├── seeds/
│   └── ravenstack/
├── snapshots/
├── tests/
├── dbt_project.yml
├── README.md
└── .gitignore
```

## Model layers

### Staging

The staging layer stays close to the raw seed tables.

Responsibilities include:

- renaming columns,
- standardizing naming conventions,
- casting data types,
- cleaning source-level inconsistencies,
- preserving the meaning of the original data.

Each raw source table should have one corresponding staging model.

Example model names:

```text
stg_ravenstack__accounts
stg_ravenstack__subscriptions
stg_ravenstack__feature_usage
stg_ravenstack__support_tickets
stg_ravenstack__churn_events
```

Staging models should not contain complex retention metrics or large business transformations.

### Intermediate

The intermediate layer contains reusable transformation logic.

Planned areas include:

- subscription periods,
- account-level usage summaries,
- support ticket summaries,
- churn timing,
- revenue calculations,
- pre-churn activity windows,
- monthly account snapshots.

Intermediate models exist to keep complex logic reusable and separate from final reporting models.

### Marts

The marts layer contains business-facing models designed for analysis and reporting.

Planned mart areas include:

```text
dim_accounts
fct_subscription_lifecycle
fct_account_usage
fct_support_activity
fct_churn_events
mart_account_health
mart_retention_metrics
```

The final model names will be based on the actual source grain and business rules discovered during development.

## Metric definitions

Metric definitions are part of the project’s analytical contract. Each metric must have a documented grain, time period, numerator, denominator, and treatment of edge cases.

Initial definitions are:

| Metric | Initial definition |
|---|---|
| Active account | An account with an active subscription at the reporting date |
| Churned account | An account with a valid churn event or ended subscription |
| Customer churn rate | Churned eligible accounts divided by eligible accounts at the start of the period |
| Revenue churn | Recurring revenue lost from churned accounts divided by recurring revenue eligible at the start of the period |
| Retention rate | Retained eligible accounts divided by eligible accounts at the start of the period |
| Usage decline | A meaningful reduction in usage compared with the account’s previous period |
| Support burden | Ticket volume, unresolved tickets, escalations, or resolution time associated with an account |
| Revenue at risk | Current recurring revenue associated with accounts showing defined retention indicators |

Metric definitions will be finalized after the grain and available fields of each source table have been verified.

## Testing strategy

Tests will protect important assumptions at the layer where those assumptions belong.

### Source and staging tests

Examples include:

- required identifiers are not null,
- source keys are unique where expected,
- account references are valid,
- date fields are populated,
- subscription status values are accepted,
- revenue values are valid.

### Intermediate model tests

Examples include:

- subscription periods do not have invalid date ranges,
- churn events reference known accounts,
- usage records belong to known accounts,
- account-period combinations are unique,
- calculated revenue values reconcile to source values.

### Mart tests

Examples include:

- one current account row exists where expected,
- business-facing keys are not null,
- mart relationships are valid,
- retention metrics use the correct population,
- no duplicate reporting-period rows exist.

Tests should validate meaningful business assumptions rather than simply increasing test counts.

## Documentation strategy

The project will document:

- source table purposes,
- table grains,
- primary and foreign keys,
- model purposes,
- column definitions,
- metric definitions,
- business assumptions,
- known limitations.

Documentation will be stored in YAML files and generated using dbt documentation commands.

## Scope

### Included in version one

- account modeling,
- subscription lifecycle modeling,
- product usage analysis,
- support activity analysis,
- churn analysis,
- recurring revenue impact,
- retention health indicators,
- dbt tests,
- dbt documentation,
- reproducible local execution.

### Not included in version one

- machine-learning churn prediction,
- real-time data pipelines,
- CRM integration,
- automated customer outreach,
- production deployment,
- cloud warehouse deployment,
- causal inference,
- intervention measurement.

## Success criteria

The project will be considered complete when:

- every source table has a documented grain,
- key assumptions are written down,
- staging models represent the raw sources accurately,
- important relationships are tested,
- subscription revenue reconciles to source data,
- churn results can be reproduced for a defined period,
- retention metrics have documented definitions,
- business-facing marts are tested and documented,
- `dbt build` completes successfully,
- the README explains the business problem and analytical outputs,
- no credentials or local database files are committed to Git.

## Known limitations

- RavenStack is a fictional company.
- The dataset is synthetic.
- The dataset does not represent actual customer behavior.
- Available fields may limit the precision of churn and revenue definitions.
- Correlation between usage, support activity, and churn should not be treated as causation.
- The project is developed locally and is not a deployed production system.

## Portfolio presentation

This project demonstrates the ability to:

- translate a business problem into data requirements,
- understand raw table grain before modeling,
- design layered dbt transformations,
- define business metrics,
- implement data quality tests,
- document models and assumptions,
- use snapshots or historical logic where appropriate,
- work with DuckDB locally,
- manage analytics code with Git,
- communicate limitations and trade-offs clearly.