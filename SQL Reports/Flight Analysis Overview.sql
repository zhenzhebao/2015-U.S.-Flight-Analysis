/*Flight Pattern by Region*/
create materialized view flights_by_region_total as 
with t as (select flight_id,origin_airport_code,origin_state,
destination_airport_code,destination_state,
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
where cancellation_reason='Normal Flight' and 
origin_airport_code!='N/A' and destination_airport_code!='N/A')
select 'Northeast' as region, count(region) as value
from t
where region='Northeast'
union all
select 'Midwest' as region, count(region) as value
from t
where region='Midwest'
union all
select 'South' as region, count(region) as value
from t
where region='South'
union all
select 'West' as region, count(region) as value
from t
where region='West'
union all
select 'Cross Region' as region, count(region) as value
from t
where region='Cross Region';

create materialized view flights_by_region_by_month as 
with t as (select flight_id,date(date_trunc('month',calendar_date)) as month,origin_airport_code,origin_state,
destination_airport_code,destination_state,
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
where cancellation_reason='Normal Flight' and 
origin_airport_code!='N/A' and destination_airport_code!='N/A')
select month,sum(case when region='Northeast' then 1 else 0 end) as Northeast,
sum(case when region='Midwest' then 1 else 0 end) as Midwest,
sum(case when region='South' then 1 else 0 end) as South,
sum(case when region='West' then 1 else 0 end) as West,
sum(case when region='Cross Region' then 1 else 0 end) as Cross_Region
from t
group by month
order by month;

/* U.S. Airport Traffic */
create materialized view busiest_slowest_airport as
with t as (select flight_id,origin_airport as airport,origin_state as state
from flight_database_view
where origin_airport_code!='N/A' and destination_airport_code!='N/A' and cancellation_reason='Normal Flight'
union all
select flight_id,destination_airport as airport,destination_state as state
from flight_database_view
where origin_airport_code!='N/A' and destination_airport_code!='N/A' and cancellation_reason='Normal Flight'),
t2 as (select airport, count(flight_id) as airport_traffic
from t
group by airport),
t3 as (select airport, airport_traffic, rank() over(order by airport_traffic desc) as desc_ranking,
rank() over(order by airport_traffic) as asc_ranking
from t2)
select 'Busiest Airport' as category, airport as value
from t3
where desc_ranking=1
union all
select 'Slowest Airport' as category, airport as value
from t3
where asc_ranking=1;

create materialized view buiest_slowest_state as
with t as (select state, flight_traffic, rank() over(order by flight_traffic DESC) as desc_ranking,
rank() over(order by flight_traffic) as asc_ranking
from flight_traffic_by_state)
select 'Busiest State' as category, state as value
from t
where desc_ranking=1
union all 
select 'Slowest State' as category, state as value
from t
where asc_ranking=1;

create materialized view flight_traffic_by_state as 
with t as (select flight_id,origin_airport as airport,origin_state as state
from flight_database_view
where origin_airport_code!='N/A' and destination_airport_code!='N/A' and cancellation_reason='Normal Flight'
union all
select flight_id,destination_airport as airport,destination_state as state
from flight_database_view
where origin_airport_code!='N/A' and destination_airport_code!='N/A' and cancellation_reason='Normal Flight')
select state, count(flight_id) as flight_traffic
from t
group by state;

/* Flight Volumne and Distance by Month*/
create materialized view flight_distance_count_by_month as
select date(date_trunc('month',calendar_date)) as month,sum(distance) as total_flight_distance,
count(flight_id) as number_of_flights
from flight_database_view
where cancellation_reason='Normal Flight'
group by date(date_trunc('month',calendar_date));

/*Flight Volume by Airline*/
create materialized view max_flight_number_airline as 
with t as (select concat(iata_code_airline,'-', flight_number) as flight_number,count(flight_id) as  number_of_flights
from flight_database_view
where cancellation_reason='Normal Flight' or cancellation_reason='Diverted Flight'
group by concat(iata_code_airline,'-', flight_number)),
t2 as (select flight_number,number_of_flights,
rank() over(order by number_of_flights DESC) as ranking
from t)
select 'Most Operated Flight' as category, flight_number as value
from t2 
where ranking=1
union all
(select 'Top Airline by Flight Volume',airline
from flight_volume
order by flight_volume desc
limit 1);

create materialized view flight_volume as 
select airline,count(flight_id) as flight_volume
from flight_database_view
where cancellation_reason='Normal Flight' or cancellation_reason='Diverted Flight'
group by airline
order by flight_volume DESC;

/*Flight Volumne Weekly Pattern*/
create materialized view flight_volume_weekly as
select trim(to_char(calendar_date,'Day'))as day,count(flight_id) as flight_volume
from flight_database_view
where cancellation_reason='Normal Flight' or cancellation_reason='Diverted Flight'
group by trim(to_char(calendar_date,'Day'));


/* flight distance by region*/
create materialized view flight_distance_distribution as 
with t as (select flight_id,distance,case 
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
where cancellation_reason='Normal Flight' and 
origin_airport_code!='N/A' and destination_airport_code!='N/A'),
t2 as (select region,max(distance)as maxmium_flight_distance,
min(distance) as minimum_flight_distance,
round(avg(distance)::numeric) as average_flight_distance
from t
group by rollup(region))
select coalesce(region,'All Regions')as region,maxmium_flight_distance,
minimum_flight_distance,average_flight_distance
from t2
order by case when region!='All Regions' then 0 else 1 end,region;

/* Flight Distance Group by Region*/
create materialized view flight_distiance_group_distribution_by_region as
with t as (select flight_id,distance,case 
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
where cancellation_reason='Normal Flight' and 
origin_airport_code!='N/A' and destination_airport_code!='N/A'),
t2 as (select flight_id,distance,region,
case 
	when distance <500 then 'Less than 500 miles'
	when distance <1000 then '500-1000 miles'
	when distance <1500 then '1000-1500 miles'
	when distance <2000 then '1500-2000 miles'
	when distance <2500 then '2000-2500 miles'
	when distance <3000 then '2500-3000 miles'
	when distance <3500 then '3000-3500 miles'
	else '3500 miles or more'
end as distance_group
from t),
t3 as (select region, distance_group,count(*) as counts
from t2
group by grouping sets ((region,distance_group),(distance_group))),
t4 as (select coalesce(region,'All Region') as region, distance_group, counts,
case 
	when distance_group='Less than 500 miles' then 1
	when distance_group='500-1000 miles'  then 2
	when distance_group='1000-1500 miles' then 3
	when distance_group='1500-2000 miles' then 4
	when distance_group='2000-2500 miles' then 5
	when distance_group='2500-3000 miles' then 6
	when distance_group='3000-3500 miles' then 7
	else 8
end as distance_group_order
from t3)
select region, distance_group, counts
from t4
order by case
	when region!='All Region' then 0 
	else 1
end,region,distance_group_order;