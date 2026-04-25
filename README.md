# Trial-to-Activation Behaviour Analysis and ELT Modelling
Product Analytics | Python | SQL | dbt | PostgreSQL
___

## Project Objective

This project defines **Trial Activation** for a workforce management SaaS product by identifying behaviours that signal product value and evaluating their relationship with conversion likelihood.

The goal is to help product teams:

- Define what a **good trial** looks like based on meaningful product behaviours
- Identify behaviours associated with **higher conversion potential**
- Determine when to **intervene during onboarding** to improve engagement
- **Track activation** consistently at scale using **warehouse-based data models**
- Generate actionable insights to **improve onboarding and conversion performance**

## Trial Activation Definition

**Trial Activation** occurs when an organisation completes key behaviours hypothesised to reflect meaningful product value and early product adoption.

These behaviours were defined using **product-value logic** and **customer journey reasoning**, then evaluated using:

- Behaviour frequency comparison
- Statistical testing (chi-square, Mann–Whitney)
- Logistic regression modelling (predictive evaluation)
- Conversion rate segmentation

Trial goals are treated as **product hypotheses**, not guaranteed conversion drivers.

## Key Findings

### 1. Conversion
- Overall conversion rate: **21.3%** (206 / 966 organisations converted)
- Median of **days from trial start to conversion**: **30 days**. Conversions occur late - at trial expiry.
- Conversions by day 30: **99** out of 206 total conversions (**48.1%**)

### 2. Engagement
- Converters and non-converters show identical median engagement: 8 events, 2 unique activities, 1 active day. This indicates **Engagement** alone does not predict conversion.

### 3. Monthly Cohorts
- Jan–Mar 2024 cohorts conversion rates: (**23.0%, 22.8%, 18.2%**). There's an obvious decline in conversion for the March 2024 cohort.

### 4. Module Usage
- Scheduling is the dominant module (88.2% adoption); all other modules used by fewer than 50% of organisations.

## Source Data Description

The raw data consist of a single table with seven attributes and 170,526 trial events that includes duplicates;

| Attribute       | Description                                      |
|-----------------|--------------------------------------------------|
| ORGANIZATION_ID | Unique identifier for each trial organisation    |
| ACTIVITY_NAME   | Name of the product activity performed           |
| TIMESTAMP       | When the activity occurred                       |
| CONVERTED       | Whether the organisation converted to paid       |
| CONVERTED_AT    | Timestamp of conversion — null if not converted  |
| TRIAL_START     | When the trial started                           |
| TRIAL_END       | Trial expiry date (trial_start + 30 days)        |

## Methodology

### 1. Data Cleaning & Exploration

Data cleaning and exploratory analysis were performed in Python using Jupyter Notebook to ensure data quality and establish baseline patterns.

Key results were summarised into a single visual to simplify interpretation of engagement and activity distributions.

See notebook: [01_data_cleaning_and_exploration.ipynb](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/notebooks/01_data_cleaning_and_exploration.ipynb)

- Raw events: **170,526**
- After deduplication: **102,895** (**67,631** exact duplicates removed)
- Distinct organisations: **966**
- Distinct activity types: **28**
- Overall conversion rate: **21.3%** (206 / 966 organisations converted)
- Median of **days from trial start to conversion**: **30 days**. This corresponds to the end of the trial period.
- Engagement distribution patterns: Derived engagement fields (total events, unique activities, active days) show **identical distribution patterns** for **converted and non-converted**.
- Activities Adoption Rate: Activites within the **Scheduling** module are most commonly adopted with **6 out of the top 10**.
- Activities Usage Volume: The **Scheduling** module still tops with **5 out of the top 10** total usage count.

#### [Fig. 1: Data Exploration Output](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/notebooks/01_data_cleaning_and_exploration_output.png)

<img src="https://raw.githubusercontent.com/jacobdbt2100/trial_activation_analysis/main/notebooks/01_data_cleaning_and_exploration_output.png" width="1200">

### 2. Conversion Driver Analysis

#### Analytical Methods Used

Multiple methods were applied to identify behavioural drivers:

- Exploratory Data Analysis (EDA)
- Event frequency comparison
- Conversion rate segmentation
- Chi-square statistical test
- Mann–Whitney U test
- Logistic regression modelling
- Feature importance analysis

This combination ensures both:

- Statistical validity
- Practical interpretability

#### [Fig. 2: Conversion Driver Analysis Output](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/notebooks/02_conversion_driver_analysis_output.png)

<img src="https://raw.githubusercontent.com/jacobdbt2100/trial_activation_analysis/main/notebooks/02_conversion_driver_analysis_output.png" width="1000">

#### Conversion Driver Caveat: Limited Predictive Evidence

Goals are designed around product-value logic, reflecting key milestones in the customer journey from setup to habitual use. However, these remain working hypotheses rather than empirically validated drivers of conversion.

Across statistical testing and logistic regression modelling, **no individual activity or engagement feature demonstrates meaningful predictive value** for conversion (chi-square p > 0.05; Mann–Whitney p > 0.05; logistic regression AUC ≈ 0.51, near the random baseline).

### 3. Trial Goals Defined

Each goal represents a milestone toward activation. **Trial Activation = Completion of all goals**.

| # | Goal                   | Description                                      | Completion Rate | Conversion Rate if Completed  | Lift Ratio |
| - | ---------------------- | ------------------------------------------------ | --------------- | ----------------------------- | ---------- |
| 1 | Core Scheduling        | Created ≥ 5 shifts                               | 46.6%           | 21.8%                         | 1.02       |
| 2 | Schedule Management    | Applied ≥ 1 shift template OR approved ≥ 1 shift | 25.6%           | 22.7%                         | 1.06       |
| 3 | Mobile Visibility      | Loaded mobile schedule ≥ 3 times                 | 36.0%           | 22.1%                         | 1.04       |
| 4 | Time Tracking          | Recorded ≥ 1 punch-in                            | 21.8%           | 22.8%                         | 1.07       |
| 5 | Early Activity Breadth | ≥ 3 different features in first 7 days of trial  | 28.3%           | 22.3%                         | 1.05       |

### 4. SQL Models

Built using **dbt layered architecture**.

#### Staging:
Materialized as **view** to keep staging models fresh and always reflect the latest source data.

- **`stg_trial_events`**: [stg_trial_events.sql](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/models/staging/stg_trial_events.sql)
  - Deduplicates on `organization_id`, `activity_name`, `timestamp`
  - Casts data types
  - Derives additional fields `activity_module` and `days_since_trial_start`

#### Marts
Materialized as **tables** to improve performance by storing cleaned, business-ready data for faster querying.

- **`fct_trial_goals`**: [fct_trial_goals.sql](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/models/marts/fct_trial_goals.sql)
  - Grain: one row per organisation.
  - Derives fields for **goal completion flags** and one for `goals_completed_count`

- **`fct_trial_activation`**: [fct_trial_activation.sql](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/models/marts/fct_trial_activation.sql)
  - Grain: one row per organisation.
  - Derives `is_activated` boolean, `activation_tier` segments, and `days_from_trial_start_to_goals_and_conversion`

### 5. Descriptive Product Metrics

Derived metrics from data models include:

- Overall Conversion Rate
- Days to Activation & Conversion
- Goal Completion Rates
- Goals Completed & Conversion Rate
- Conversion Rate by Cohort Month
- Module Adoption Rate

These metrics help teams monitor:

- Trial health
- Feature effectiveness
- Onboarding performance

#### [Fig. 3: Product Metrics Output](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/notebooks/03_descriptive_analysis_and_product_metrics_output.png)

<img src="https://raw.githubusercontent.com/jacobdbt2100/trial_activation_analysis/main/notebooks/03_descriptive_analysis_and_product_metrics_output.png" width="1200">

### 6. Repository Structure

```text
trial_activation_analysis/
│
├── dataset/
│   ├── exports/
│   │  ├── df_activity_pivot_flag.csv
│   │  ├── df_organization.csv
│   │  ├── df_organization_act_count.csv
│   │  ├── df_organization_act_flag.csv
│   │  ├── df_trial.csv
│   │  ├── fct_trial_activation.csv
│   │  └── stg_trial_events.csv
│   │ 
│   └── snippet_data/
│      └── trial_events.csv
│
├── models/
│   ├── marts/
│   │   ├── fct_trial_activation.sql          # mart: activation flag per organisation
│   │   ├── fct_trial_goals.sql               # mart: goal completion per organisation
│   │   └── marts_schema.yml                  # dbt mart models tests
│   │
│   └── staging/                              # staging: cast, dedup, enrich raw events
│       ├── stg_trial_events.sql
│       └── staging_schema.yml                # dbt source + staging models tests
│
├── notebooks/
│   ├── 01_data_cleaning_and_exploration.ipynb
│   ├── 01_data_cleaning_and_exploration_output.png
│   ├── 02_conversion_driver_analysis.ipynb
│   ├── 02_conversion_driver_analysis_output.png
│   ├── 03_descriptive_analysis_and_product_metrics.ipynb
│   └── 03_descriptive_analysis_and_product_metrics_output.png
│
├── .gitignore
├── README.md
├── dbt_project.yml
└── requirements.txt
```

## Recommendations

- **Introduce mid-trial reminders (Day 7–14)**: Encourage organisations with low early activity to create shifts and load schedules before the trial ends.

- **Make shift creation a required early step**: Prioritise scheduling setup during onboarding since it is the most widely used and foundational feature.

- **Encourage use of multiple features early**: Prompt users to try at least 3 different features within the first 7 days to increase product exposure.

- **Promote early use of time tracking**: Guide users to complete their first punch-in/punch-out during onboarding.

- **Investigate declining conversion in later cohorts**: Review onboarding flow, product changes, or user mix that may explain lower conversion rates in recent months.

- **Track Trial Activation as a key KPI**: Monitor activation rate alongside conversion to measure onboarding effectiveness.

- **Flag low-progress trialists early**: Identify organisations that fail to complete key actions and trigger targeted support.

- **Use activation data to support ongoing decisions**: Build dashboards that track goal completion and activation trends over time.

## Project Setup & Reproduction

### 1. Clone Repository

```powershell
git clone https://github.com/jacobdbt2100/trial_activation_analysis.git
cd trial_activation_analysis
```
### 2. Install Dependencies

```powershell
pip install -r requirements.txt
```

### 3. Run dbt Models

```powershell
dbt run
```

### 4. Run Tests

```powershell
dbt test
```

### 5. Open Notebooks

Run notebooks to reproduce analysis and visuals.

## Tools Used
Python | pandas | matplotlib | seaborn | SQL | dbt | Jupyter Notebook | Git/GitHub | VS Code

## Author

**Jacob Joshua**

Product Analyst & Analytics Engineer || SaaS & FinTech ||

Growth, Retention, & Behaviour Analytics || Data Modelling ||

SQL • dbt • Python • Power BI • Excel

- [X(Twitter)](https://x.com/jacobdbt2100_2)
- [LinkedIn](https://www.linkedin.com/in/jacobjoshua675/)
- [GitHub](https://github.com/jacobdbt2100/Data-Analytics-Projects/blob/main/README.md)
