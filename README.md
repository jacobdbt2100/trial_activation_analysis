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

Activation is treated as a **product hypothesis**, not a guaranteed conversion driver.

## Methodology

### 1. Data Cleaning & Exploration
### 2. Conversion Driver Analysis
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
### 6. Repo Structure

## Key Findings


## Recommendations


## How to Run This Project


## Tools Used
Python | pandas | matplotlib | seaborn | SQL | dbt | Jupyter Notebook | Git/GitHub | VS Code

## Author

Jacob Joshua

Data Analyst - Product & Behaviour Analytics

- [GitHub](https://github.com/jacobdbt2100/Data-Analytics-Projects/blob/main/README.md)
- [LinkedIn](https://www.linkedin.com/in/jacobjoshua675/)
