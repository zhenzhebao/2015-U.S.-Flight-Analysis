/* Cancellation Analysis*/

/* Flight Cancellation by reason*/
create materialized view flight_cancellation_reason as
select cancellation_reason, count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight' 
and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by cancellation_reason;

/*Flight Cancellation by month*/
create materialized view flight_cancellation_by_month as 
select date(date_trunc('month',calendar_date)) as month,count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight' 
and origin_airport_code!='N/A'
and destination_airport_code!='N/A'
group by date(date_trunc('month',calendar_date));

create materialized view min_max_cancellation_month as
with t as (select month, number_of_canceled_flights,
rank() over(order by number_of_canceled_flights desc) as desc_ranking,
rank() over(order by number_of_canceled_flights) as asc_ranking
from flight_cancellation_by_month)
select 'Month with Most Cancellations' as category, month as value
from t
where desc_ranking=1
union all
select 'Month with Fewest Cancellations' as category, month as value
from t
where asc_ranking=1;

/*Flight Cancellation by airline*/
create materialized view flight_cancellation_airline as
with t as (select airline, count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight'
group by airline),
t2 as (select airline,count(flight_id) as number_of_scheduled_flights
from flight_database_view
group by airline)
select t.airline,t.number_of_canceled_flights,
round(t.number_of_canceled_flights*1.0/t2.number_of_scheduled_flights,4) as cancellation_rate
from t
join t2
on t.airline=t2.airline;

create materialized view min_max_cancellation_rate_airline as
with t as (select airline, cancellation_rate,
rank() over(order by cancellation_rate desc) as desc_ranking,
rank() over(order by cancellation_rate) as asc_ranking
from flight_cancellation_airline)
select 'Highest Cancellation Rate' as category, airline as value
from t
where desc_ranking=1
union all
select 'Lowest Cancellation Rate' as category, airline as value
from t 
where asc_ranking=1;

create materialized view max_aircraft_flight_cancellation as
(with t as (select tail_number, count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight' 
and origin_airport_code!='N/A'
and destination_airport_code!='N/A' and tail_number!='Unknown'
group by tail_number),
t2 as (select tail_number, number_of_canceled_flights,
rank() over(order by number_of_canceled_flights desc) as desc_ranking
from t)
select 'Most Cancellations by Aircraft' as category, tail_number as value
from t2
where desc_ranking=1)
union all
(with t as (select concat(iata_code_airline,'-',flight_number) as flight_number,
count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight' 
and origin_airport_code!='N/A' and destination_airport_code!='N/A'
group by concat(iata_code_airline,'-',flight_number)),
t2 as (select flight_number,number_of_canceled_flights,
rank() over(order by number_of_canceled_flights desc) as desc_ranking
from t)
select 'Most Cancellations by Flight' as category, flight_number as value
from t2
where desc_ranking=1);

/*Flight Cancellation by region*/
create materialized view origin_airport_cancellation as
with t as (select origin_airport, count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight' 
and origin_airport_code!='N/A' and destination_airport_code!='N/A'
group by origin_airport)
select origin_airport,number_of_canceled_flights,
rank() over(order by number_of_canceled_flights desc) as desc_ranking
from t;

create materialized view destination_airport_cancellation as
with t as (select destination_airport,count(flight_id) as number_of_canceled_flights
from flight_database_view
where cancellation_reason!='Diverted Flight' and cancellation_reason!='Normal Flight' 
and origin_airport_code!='N/A' and destination_airport_code!='N/A'
group by destination_airport)
select destination_airport,number_of_canceled_flights,
rank() over(order by number_of_canceled_flights desc) as desc_ranking
from t;

create materialized view origin_destination_airport_most_cancellation as
select 'Origin Airport with Most Cancellations' as category, origin_airport as value
from origin_airport_cancellation
where desc_ranking=1
union all
select 'Destination Airport with Most Cancellations' as category, destination_airport as value
from destination_airport_cancellation
where desc_ranking=1;

create materialized view flight_cancellation_region as 
with t as (select flight_id,cancellation_reason,
case 
	when origin_state in ('CT','ME','MA','NH','RI','VT','NJ','NY','PA') 
	and  destination_state in ('CT','ME','MA','NH','RI','VT','NJ','NY','PA')
	then 'Northeast'
	when origin_state in ('IL','IN','MI','OH','WI','IA','KS','MN','MO','NE','ND','SD')
	and destination_state in ('IL','IN','MI','OH','WI','IA','KS','MN','MO','NE','ND','SD')
	then 'Midwest'
	when origin_state in ('DE','FL','GA','MD','NC','SC','VA','DC','WV','AL','KY','MS',
	'TN','AR','LA','OK','TX') and destination_state in ('DE','FL','GA','MD','NC','SC','VA','DC',
	'WV','AL','KY','MS','TN','AR','LA','OK','TX') then 'South'
	when origin_state in ('AZ','CO','ID','MT','NV','NM','UT','WY','AK','CA','HI','OR','WA')
	and  destination_state in ('AZ','CO','ID','MT','NV','NM','UT','WY','AK','CA','HI','OR','WA')
	then 'West'
	else 'Cross Region'
end as region
from flight_database_view
where origin_airport_code!='N/A' and destination_airport_code!='N/A')
select region, 
sum(case
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
	else 0
end)as number_of_canceled_flights, count(flight_id) as total_scheduled_flights
from t
group by region;