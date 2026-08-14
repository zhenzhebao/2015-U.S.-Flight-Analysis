/* Flight Diversion Analysis*/

/* Note: Only flights with valid origin and destination information are included in the Flight Diversion Analysis, 
unless otherwise specified.*/
/* Flight Diversion by Month*/
create materialized view diverted_flights_min_max_month as 
with t as (select month, number_of_diverted_flights,
rank() over(order by number_of_diverted_flights desc) as desc_ranking,
rank() over(order by number_of_diverted_flights) as asc_ranking
from flight_diversion_by_month)
select 'Month with most diverted flights' as category, month as value
from t
where desc_ranking=1
union all
select 'Month with least diverted flights' as category, month as value
from t
where asc_ranking=1;

create materialized view flight_diversion_by_month as
select date(date_trunc('month',calendar_date)) as month,count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight' and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by date(date_trunc('month',calendar_date));

/*Flight Diversion by Original Scheduled Destination*/
create materialized view flight_diversion_airport_state as
(with t as (select destination_airport, count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight' and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by destination_airport),
t2 as (select destination_airport, number_of_diverted_flights, 
rank() over(order by number_of_diverted_flights desc) as ranking
from t)
select 'Scheduled Destination with Most Diverted Flights' as category, destination_airport as value
from t2
where ranking=1)
union all
(with t as (select destination_state,count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight' and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by destination_state),
t2 as (select destination_state,number_of_diverted_flights,
rank() over(order by number_of_diverted_flights desc) as desc_ranking,
rank() over(order by number_of_diverted_flights) as asc_ranking
from t)
select 'Scheduled Destination State with Most Diverted Flights' as category, destination_state as value
from t2
where desc_ranking=1
union all
select 'Scheduled Destination State with Least Diverted Flights' as category,destination_state as value
from t2
where asc_ranking=1);

create materialized view flight_diversion_state as 
select destination_state,count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight' and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by destination_state;

/* Flight Diversion by Airline*/
create materialized view flight_diversion_airline as 
with t as (select airline, count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight'
group by airline),
t2 as (select airline,count(flight_id) as total_scheduled_flights
from flight_database_view
group by airline)
select t.airline,number_of_diverted_flights,total_scheduled_flights,
round(number_of_diverted_flights*1.0/total_scheduled_flights,4) as diversion_rate
from t
join t2
on t.airline=t2.airline;

create materialized view airline_min_max_diversion as 
with t as (select airline, diversion_rate,
rank() over(order by diversion_rate desc) as desc_ranking,
rank() over(order by diversion_rate) as asc_ranking
from flight_diversion_airline)
select 'Airline with Lowest Diversion Rate' as category, airline as value
from t
where asc_ranking=1
union all
select 'Airline with Highest Diversion Rate' as category, airline as value
from t
where desc_ranking=1;

create materialized view flight_aircraft_most_diversions as 
(with t as (select tail_number,count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight' and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by tail_number),
t2 as (select tail_number,number_of_diverted_flights,
rank() over(order by number_of_diverted_flights desc) as desc_ranking
from t)
select 'Aircraft with Most Diversions' as category, tail_number as value
from t2
where desc_ranking=1)
union all
(with t as (select concat(iata_code_airline,'-',flight_number) as flight_number,
count(flight_id) as number_of_diverted_flights
from flight_database_view
where cancellation_reason='Diverted Flight' and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by concat(iata_code_airline,'-',flight_number)),
t2 as (select flight_number,number_of_diverted_flights,
rank() over(order by number_of_diverted_flights desc) as desc_ranking
from t)
select 'Flight with Most Diversions' as category, flight_number as value
from t2
where desc_ranking=1);