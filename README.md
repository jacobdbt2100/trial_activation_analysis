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

- Core Scheduling Setup
- Schedule Management
- Mobile Visibility
- Time Tracking Usage
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

| Goal                          | Description                      | Example Activities              |
| ----------------------------- | -------------------------------- | ------------------------------- |
| Goal 1 — Core Scheduling      | Organisation sets up schedules   | Shift Created, Template Applied |
| Goal 2 — Schedule Management  | Staff interaction with schedules | Shift Swap, Assignment Changes  |
| Goal 3 — Workforce Visibility | Schedule visibility across users | Schedule Loaded                 |
| Goal 4 — Time Tracking        | Active time logging              | Punch In / Out                  |
| Goal 5 — Workflow Breadth     | Multi-feature usage              | Messaging, Absence, Payroll     |




### 4. SQL Models
### 5. Descriptive Product Metrics
### 6. Repo Structure

## Key Findings


## Recommendations


## How to Run This Project


## Tools Used
Python | pandas | matplotlib | seaborn | SQL | dbt | Jupyter Notebook | Git/GitHub | VSCode

## Author

Jacob Joshua

Data Analyst - Product & Behaviour Analytics

- [GitHub](https://github.com/jacobdbt2100/Data-Analytics-Projects/blob/main/README.md)
- [LinkedIn](https://www.linkedin.com/in/jacobjoshua675/)
