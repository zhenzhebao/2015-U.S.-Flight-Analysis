
/* Daily Cancellation rate and Diversion rate*/
create materialized view daily_diversion_cancellation_rate as
with t as (select calendar_date,
sum(case 
	when cancellation_reason='Diverted Flight' then 1
	else 0
end) as number_of_diverted_flights,
sum(case
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
	else 0
end) as number_of_canceled_flights,
count(flight_id) as number_of_scheduled_flights
from flight_database_view
where origin_airport_code!='N/A' and destination_airport_code!='N/A'
and calendar_date>='2015-01-21' and calendar_date<'2015-02-06'
group by calendar_date)
select calendar_date,number_of_diverted_flights,number_of_canceled_flights,number_of_scheduled_flights,
round(number_of_diverted_flights*1.0/number_of_scheduled_flights,4) as diversion_rate,
round(number_of_canceled_flights*1.0/number_of_scheduled_flights,4) as cancellation_rate
from t;

/* Dailu Flight record within this period*/
create materialized view daily_flight_status as 
select calendar_date,flight_id,cancellation_reason,origin_airport,origin_state,
destination_airport,destination_state,
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
where origin_airport_code!='N/A' and destination_airport_code!='N/A'
and calendar_date>='2015-01-21' and calendar_date<'2015-02-06';

/* Cancellation rate and diversion rate by region for entire period*/
create materialized view region_cancellation_diversion_blizzard as 
with t as (select region, 
sum(case
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
	else 0
end) as number_of_canceled_flights,
sum(case
	when cancellation_reason='Diverted Flight' then 1
	else 0
end) as number_of_diverted_flights,
count(flight_id) as number_of_scheduled_flights
from daily_flight_status
group by region)
select region, round(number_of_canceled_flights*1.0/number_of_scheduled_flights,4) as cancellation_rate,
round(number_of_diverted_flights*1.0/number_of_scheduled_flights,4) as diversion_rate
from t;

/* Daily Cancellation rate and diversion rate*/
create materialized view daily_region_diversion_cancellation_rate as 
with t as (select region, calendar_date, 
sum(case
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
	else 0
end) as number_of_canceled_flights,
sum(case
	when cancellation_reason='Diverted Flight' then 1
	else 0
end) as number_of_diverted_flights,
count(flight_id) as number_of_scheduled_flights
from daily_flight_status
group by region, calendar_date)
select region, calendar_date,
round(number_of_canceled_flights*1.0/number_of_scheduled_flights,4) as cancellation_rate,
round(number_of_diverted_flights*1.0/number_of_scheduled_flights,4) as diversion_rate
from t;

/* Airport and State with most flight cancellations and diversions*/
create materialized view most_cancel_divert_state_airport_blizzard as
with t as (select origin_airport, 
sum(case
    when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
    else 0
end) as number_of_canceled_flights
from daily_flight_status
group by origin_airport),
t2 as (select origin_airport,
rank() over(order by number_of_canceled_flights desc) as desc_ranking_canceled
from t)
select 'Origin Airport with most Cancellations' as category, origin_airport as value
from t2
where desc_ranking_canceled=1
union all
(with t as (select destination_airport, 
sum(case
    when cancellation_reason='Diverted Flight' then 1
    else 0
end) as number_of_diverted_flights,
sum(case
    when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
    else 0
end) as number_of_canceled_flights
from daily_flight_status
group by destination_airport),
t2 as (select destination_airport,
rank() over(order by number_of_diverted_flights desc) as desc_ranking_diverted,
rank() over(order by number_of_canceled_flights desc) as desc_ranking_canceled
from t)
select 'Destination Airport with most Cancellations' as category, destination_airport as value
from t2
where desc_ranking_canceled=1
union all 
select 'Destination Airport with most Diversions' as category, destination_airport as value
from t2
where desc_ranking_diverted=1)
union all
(with t as (select origin_state,
sum(case 
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
	else 0
end) as number_of_canceled_flights
from daily_flight_status
group by origin_state),
t2 as (select origin_state,number_of_canceled_flights,
rank() over(order by number_of_canceled_flights desc) as desc_ranking_canceled
from t)
select 'Origin State with most Cancellations' as category, origin_state as value
from t2
where desc_ranking_canceled=1)
union all
(with t as (select destination_state,
sum(case
	when cancellation_reason='Diverted Flight' then 1 
	else 0
end) as number_of_diverted_flights,
sum(case 
	when cancellation_reason!='Normal Flight' and cancellation_reason!='Diverted Flight' then 1
	else 0
end) as number_of_canceled_flights
from daily_flight_status
group by destination_state),
t2 as (select destination_state,
rank() over(order by number_of_diverted_flights desc) as desc_ranking_diverted,
rank() over(order by number_of_canceled_flights desc) as desc_ranking_canceled
from t)
select 'Destination State with most Cancellations' as category, destination_state as value
from t2 
where desc_ranking_canceled=1
union all 
select 'Destination State with most Diversions' as category, destination_state as value
from t2 
where desc_ranking_diverted=1);