# Trial-to-Activation Behaviour Analysis and ELT Modelling
Product Analytics | dbt Modelling | Python | SQL
___

This project defines **Trial Activation** for a workforce management SaaS product by identifying behaviours that signal product value and predicting conversion likelihood.

The goal is to help product teams understand:

- What a **good trial** looks like
- Which behaviours signal **high conversion potential**
- When to **intervene during onboarding**
- How to track activation at scale using **warehouse models**

## Project Objective

Trial users complete many activities, but not all behaviours drive conversion.

This project answers:

1. Which product activities indicate conversion likelihood?
2. What set of behaviours defines **Trial Activation**?
3. How can **activation be tracked** consistently in a data warehouse?
4. What insights help improve onboarding and conversion rates?

## Trial Activation Definition

**Trial Activation** occurs when an organisation completes key behaviours that demonstrate real product value.

Activation is defined as completing:

- Core Scheduling
- Schedule Management
- Mobile Visibility
- Time Tracking
- Early Activity (Feature) Breadth

These behaviours were selected using:

- Statistical testing
- Behaviour frequency comparison
- Logistic regression modelling
- Conversion rate segmentation

Trial goals are treated as **product hypotheses**, not guaranteed conversion drivers.

## Key Findings

### 1. Conversion
- Overall conversion rate: **21.3%** (206 / 966 organisations converted)
- Median of **days from trial start to conversion**: **30 days**. This corresponds to the end of the trial period.
- Conversions by day 30: **99** out of 206 total conversions (**48.1%**)

### 2. Engagement
- Converters and non-converters show identical median engagement: 8 events, 2 unique activities, 1 active day. This indicates **Engagement** alone does not predict conversion.

### 3. Monthly Cohorts
- Jan–Mar 2024 cohorts conversion rates: (**23.0%, 22.8%, 18.2%**). There's an obvious decline in conversion for the March 2024 cohort.

### 4. Module Usage
- Scheduling is the dominant module (88.2% adoption); all other modules used by fewer than 50% of organisations.

## Data Description

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

<img src="https://raw.githubusercontent.com/jacobdbt2100/trial_activation_analysis/main/notebooks/01_data_cleaning_and_exploration_output.png" width="1000">

### 2. Conversion Driver Analysis

#### [Fig. 2: Conversion Driver Analysis Output](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/notebooks/02_conversion_driver_analysis_output.png)

<img src="https://raw.githubusercontent.com/jacobdbt2100/trial_activation_analysis/main/notebooks/02_conversion_driver_analysis_output.png" width="900">

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
### 5. Descriptive Product Metrics

#### [Fig. 3: Product Metrics Output](https://github.com/jacobdbt2100/trial_activation_analysis/blob/main/notebooks/03_descriptive_analysis_and_product_metrics_output.png)

<img src="https://raw.githubusercontent.com/jacobdbt2100/trial_activation_analysis/main/notebooks/03_descriptive_analysis_and_product_metrics_output.png" width="1000">

### 6. Repo Structure


## Recommendations


## How to Run This Project


## Tools Used
Python | pandas | matplotlib | seaborn | SQL | dbt | Jupyter Notebook | Git/GitHub | VS Code

## Author

**Jacob Joshua**

Data Analyst - Product & Behaviour Analytics

- [GitHub](https://github.com/jacobdbt2100/Data-Analytics-Projects/blob/main/README.md)
- [LinkedIn](https://www.linkedin.com/in/jacobjoshua675/)
