# 2015 U.S. Flight Analysis

## Project Overview

This project explores U.S. air travel patterns in 2015 using the 2015 Flight Delays and Cancellations dataset from the U.S. Department of Transportation (DOT). The analysis begins by presenting key KPIs to provide a quick summary of flight activity, followed by analyses of normal, diverted, and canceled flights from multiple perspectives. The project concludes with an in-depth analysis of how winter storms in early 2015 affected U.S. air travel. Relevant weather data is retrieved from the Open-Meteo Historical Weather API to investigate which weather factors might be associated with severe flight disruptions at Chicago O'Hare International Airport during this period.

**Data Source**

https://www.kaggle.com/datasets/usdot/flight-delays

https://open-meteo.com/en/docs/historical-weather-api


## Tools and Skills

### Tools
- Tableau
- PostgreSQL
- Python
- Requests Library

### Tableau Skills
- Parameters & Calculated Fields
- Table Calculations
- Interactive Dashboard Filters
- Trend Lines
- Reference Bands & Annotations
- Dual-Axis Charts
- Customized Tooltips
- Maps & Geographic Analysis
- Dynamic Zone Visibility
- Dashboard Design

### SQL / PostgreSQL
- Relational Database Design
- Data Cleaning & Validation
- Data Type Conversion
- CTEs, Subqueries & Correlated Subqueries
- Joins
- Conditional Aggregation
- Grouping Sets & Rollup
- Window Functions &  Window Frames (rows, range)
- CASE Statements
- Date & String Functions
- Views & Materialized Views
- KPI & Rate Calculations

### API & Data Engineering
- REST API Integration
- API Request Parameters
- Retry Logic
- Error Handling
- Response Validation
- ETL Pipeline Development
- Data Integration

### Data Analysis
- KPI Definition
- Metric Definition & Business Rules
- Data Quality Assessment
- Trend & Pattern Analysis
- Comparative Analysis
- Event-Based Analysis
- Diagnostic Analysis
- Insight Communication

## Analysis and Dashboards
### 2015 U.S. Flight Statistics
  <img width="70%" alt="Screenshot 2026-08-14 at 15 31 54" src="https://github.com/user-attachments/assets/3181dcdb-1ccb-444d-975f-7f66a4401e05" />


### January 2015 North American Blizzard Analysis
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
- Among flights operating within the Northeast, 22.73% were canceled, compared with only 0.87% of flights operating within the South. In contrast, flights operating within the West and cross region flights both had a 0.27% diversion rate, compared with 0.09% for the South. 

### Daily Flight Cancellation and Diversion Rates
- From a daily perspective, 98.76% of flights operating within the Northeast were canceled on January 27, while 89.80% were canceled on February 2. 
- The Northeast diversion rate reached 0.72% on January 24, while the diversion rate for cross region flights reached 1.04% on February 1.

## Chicago O'Hare Flight Disruption Analysis
The analysis of how winter storms affected U.S. air travel revealed that Chicago O'Hare International Airport experienced the highest number of flight cancellations for both departing and arriving flights during this period. Relevant weather data, such as temperature, snowfall, and wind speed, was retrieved from the Open-Meteo Historical Weather API and used to create a total of five charts in Tableau to investigate the relationship between weather conditions and flight disruptions, including cancellations and diversions.

The graph shows that February 1 was the worst day, with both cancellation and diversion rates reaching their highest levels. The situation gradually returned to normal by February 5. Heavy snowfall might have been the main factor contributing to the flight disruptions. Although wind speed also peaked on February 1, relatively high wind speeds occurred on January 25 and January 29 without causing similarly high cancellation or diversion rates. A similar pattern can be seen with temperature. On January 26–27 and February 2–5, temperatures remained below the freezing point for the entire day, but cancellation and diversion rates were much lower. Therefore, compared with temperature and wind speed, heavy snowfall appears to have had a stronger relationship with the severe flight disruptions on February 1 at Chicago O’Hare International Airport. 

## Data Cleaning 
- **Invalid airport codes:** Some flights contained origin or destination airport codes that could not be matched to the airport reference data. To preserve these flight records, unmatched airports were mapped to a designated N/A airport record.
- **Date standardization:** Separate date-related fields were combined into a single calendar date, and unnecessary date columns were removed afterward.
- **Distance standardization:** Small differences were found in the recorded distance for some identical airport pairs. These values were standardized using the minimum recorded distance for each route.
- **Delay variables:** Air system, security, airline, late-aircraft, and weather delay columns were removed because of substantial missing data.
- **Flight status classification:** CASE statements were used with cancellation and diversion indicators to classify flights as normal, diverted, or canceled and to handle missing cancellation-reason values.
- **Time formatting:** Flight time fields stored as four-digit numeric values were converted into standard time formats.
- **Missing values:** The remaining null values represented unavailable information rather than invalid flight records. Therefore, the records were retained and NOT NULL constraints were not applied to those fields.

## Database Design 
  - Because the same flight number can be associated with different origin and destination airport pairs, Flight Information and Flight Schedule are connected directly to the Flight table.
    <img width="70%" alt="Flights" src="https://github.com/user-attachments/assets/7c4cc5c9-205a-4b40-a1af-21b02571e512" />
    
    <img width="70%" alt="Screenshot 2026-08-30 at 19 17 21" src="https://github.com/user-attachments/assets/702d0260-862d-426e-b6a2-23660db15be2" />



