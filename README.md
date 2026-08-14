# 2015 U.S. Flight Analysis

## Project Overview

This project explores U.S. air travel patterns in 2015 using the 2015 Flight Delays and Cancellations dataset from the U.S. Department of Transportation (DOT). The analysis begins by presenting key KPIs to provide a quick summary of flight activity, followed by analyses of normal, diverted, and canceled flights from multiple perspectives. The project concludes with an in-depth analysis of how winter storms in early 2015 affected U.S. air travel. 

Data Source: https://www.kaggle.com/datasets/usdot/flight-delays


## Tools and skills

### Tools
- Tableau
- PostgreSQL

### Tableau Skills
- Calculated Fields
- Table Calculations
- Interactive Dashboard Filters
- Trend Lines
- Reference Bands & Annotations
- Dual-Axis Charts
- Customized Tooltips
- Maps & Geographic Analysis
- Dashboard Design

### SQL / PostgreSQL
- Relational Database Design
- Data Cleaning & Validation
- Data Type Conversion
- CTEs & Subqueries
- Joins
- Conditional Aggregation
- Window Functions
- CASE Statements
- Date & String Functions
- Views & Materialized Views
- KPI & Rate Calculations

### Data Analysis
- KPI Definition
- Metric Definition & Business Rules
- Data Quality Assessment
- Trend & Pattern Analysis
- Comparative Analysis
- Event-Based Analysis
- Insight Communication

## Analysis and Dashboards
### 2015 U.S. Flight Statistics
  <img width="70%" alt="Screenshot 2026-08-14 at 15 31 54" src="https://github.com/user-attachments/assets/3181dcdb-1ccb-444d-975f-7f66a4401e05" />


### January 2015 North American blizzard Analysis
  <img width="70%" alt="Screenshot 2026-08-14 at 15 34 17" src="https://github.com/user-attachments/assets/8f3ef8e5-98be-4199-a753-0d66bd8a4f58" />

  <img width="70%" alt="Screenshot 2026-08-14 at 15 35 03" src="https://github.com/user-attachments/assets/5a302e65-9f3e-46ff-a96e-49610745ab53" />

  <img width="70%" alt="Screenshot 2026-08-14 at 15 36 33" src="https://github.com/user-attachments/assets/0b1237cc-fe44-4c7f-9ab7-5388f12a20f8" />

  <img width="70%" alt="Screenshot 2026-08-14 at 15 36 59" src="https://github.com/user-attachments/assets/04033572-f197-4834-bb8f-c59801d1915d" />

## Key Insights

### Overall Flight Diversion and Cancellation Patterns
- The patterns of flight diversions and cancellations differed between the two winter storms. 
- The peak cancellation rates were relatively similar, while the diversion rate was significantly higher during the January 31–February 2 winter storm. 
- Peak flight diversions occurred around the middle of each winter storm, while peak flight cancellations occurred near the end. 

### Flight Cancellations and Diversions by Region
- Cancellation and diversion patterns also differed between flights operating within the same region and those crossing regions. 
- Flights operating within the South were less affected overall, with the lowest cancellation and diversion rates. 
- Among flights operating within the Northeast, 22.73% were cancelled, compared with only 0.87% of flights operating within the South. In contrast, flights operating within the West and cross region flights both had a 0.27% diversion rate, compared with 0.09% for the South. 

### Daily Flight Cancellation and Diversion Rates
- From a daily perspective, 98.76% of flights operating within the Northeast were cancelled on January 27, while 89.80% were cancelled on February 2. 
- The Northeast diversion rate reached 0.72% on January 24, while the diversion rate for cross region flights reached 1.04% on February 1.

## Data Cleaning 
- **Invalid airport codes:** Some flights contained origin or destination airport codes that could not be matched to the airport reference data. To preserve these flight records, unmatched airports were mapped to a designated N/A airport record.
- **Date standardization:** Separate date-related fields were combined into a single calendar date, and unnecessary date columns were removed afterward.
- **Distance standardization:** Small differences were found in the recorded distance for some identical airport pairs. These values were standardized using the minimum recorded distance for each route.
- **Delay variables:** Air system, security, airline, late-aircraft, and weather delay columns were removed because of substantial missing data.
- **Flight status classification:** CASE statements were used with cancellation and diversion indicators to classify flights as normal, diverted, or canceled and to handle missing cancellation-reason values.
- **Time formatting:** Flight time fields stored as four-digit numeric values were converted into standard time formats.
- **Missing values:** Because of a NULL represented unavailable information rather than an invalid flight record, the record was retained and NOT NULL constraints were not applied to those fields. 

