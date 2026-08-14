/*Overview Dashboard*/

/*KPI Part 1*/
create materialized view flight_data_overview as 
select 'Total Flights' as category, count(flight_id) as value
from flight_database_view
union all
select 'Diverted Flights Percentage',
sum(case when cancellation_reason='Diverted Flight' then 1 end)*1.0/count(flight_id)
from flight_database_view
union all
select 'Canceled Flights Percentage',
sum(case
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
end)*1.0/count(flight_id)
from flight_database_view
union all
select 'Number of Flights Per Day',
round(count(flight_id)*1.0/count(distinct calendar_date),2)
from flight_database_view
union all
select 'Average Departure Delay', round(avg(departure_delay),2)
from flight_database_view
union all
select 'Average Arrival Delay',round(avg(arrival_delay),2)
from flight_database_view
union all
select 'Number of Airlines',count(distinct iata_code_airline)
from flight_database_view
union all
select 'Number of Airports',
(with t as (select origin_airport_code as airport
from flight_database_view
union all
select destination_airport_code
from flight_database_view)
select count(distinct airport)
from t
where airport!='N/A');

/*KPI Part 2*/
create view diverted_flights_by_month as (
select to_char(calendar_date,'YYYY-MM') as year_month,count(flight_id) as diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight'
group by to_char(calendar_date,'YYYY-MM'));

create view canceled_flights_by_month as
select to_char(calendar_date,'YYYY-MM') as year_month, count(flight_id) as canceled_flights
from flight_database_view
where cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight'
group by to_char(calendar_date,'YYYY-MM');

create materialized view Highest_diverted_canceled_flights_month as 
with t as (select year_month as month_with_highest_diverted_flights,
(select year_month 
from canceled_flights_by_month
order by canceled_flights desc
limit 1) as month_with_highest_canceled_flights
from diverted_flights_by_month
order by diverted_flights desc
limit 1)
select 'Month with Highest Diverted Flights' as category, month_with_highest_diverted_flights as value
from t
union all
select 'Month with Highest Canceled Flights' as category,month_with_highest_canceled_flights as value
from t;