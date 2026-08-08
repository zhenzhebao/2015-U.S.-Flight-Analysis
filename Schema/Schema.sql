/* Flight database */

/*This script contains the process about data cleaning and constructing of a relational database. */
/* create Airline and Airport table and import add a N/A reocrd in airport table 
 * as some rows has invalid data*/
create table us_airline(
iata_code_airline varchar(2) constraint iata_code_airline_pk primary key,
airline varchar(60) not null);

create table us_airport_raw(
iata_code_airport varchar(3),
airport varchar(200),
city varchar(30),
state char(2),
country char(3),
latitude numeric(8,6),
longitude numeric(9,6)
);

create table us_airport(
airport_id int generated always as identity constraint airport_id_pk primary key,
iata_code_airport varchar(3),
airport varchar(200),
city varchar(30),
state char(2),
country char(3),
latitude numeric(8,6),
longitude numeric(9,6)
);
insert into us_airport(iata_code_airport,airport,city,state,country,latitude,longitude)
select nullif(trim(iata_code_airport),'') as iata_code_airport,
nullif(trim(airport),'') as airport,nullif(trim(city),'') as city,
nullif(trim(state),'') as state,nullif(trim(country),'') as country,latitude,longitude
from us_airport_raw;
drop table us_airport_raw;
/* clean up flight data*/

create table flights_raw(
year varchar(200),
month varchar(200),
day varchar(200),
day_of_week varchar(200),
airline varchar(200),
flight_number varchar(200),
tail_number varchar(200),
origin_airport varchar(200),
destination_airport varchar(200),
scheduled_departure varchar(200),
departure_time varchar(200),
departure_delay varchar(200),
taxi_out varchar(200),
wheels_off varchar(200),
scheduled_time varchar(200),
elapsed_time varchar(200),
air_time varchar(200),
distance varchar(200),
wheels_on varchar(200),
taxi_in varchar(200),
scheduled_arrival varchar(200),
arrival_time varchar(200),
arrival_delay varchar(200),
diverted varchar(200),
cancelled varchar(200),
cancellation_reason varchar(200),
air_system_delay varchar(200),
security_delay varchar(200),
airline_delay varchar(200),
late_aircraft_delay varchar(200),
weather_delay varchar(200));

/* some airport in the flight data is not in the airport table, airline table is good*/
select count(*) as total_database_record_count,(select count(*) from flights_raw) as raw_data_count
from flights_raw f
join us_airport a
on a.iata_code_airport=f.origin_airport
join us_airport ar
on ar.iata_code_airport=f.destination_airport;

select count(*) as total_database_record_count,(select count(*) from flights_raw) as raw_data_count
from flights_raw f
join us_airline a
on f.airline=a.iata_code_airline;

/* check missing value */
with t as (select nullif(trim(year),'') as year,nullif(trim(month),'') as month,
nullif(trim(day),'') as day,nullif(trim(day_of_week),'') as day_of_week,
nullif(trim(airline),'') as airline,nullif(trim(flight_number),'') as flight_number,
nullif(trim(tail_number),'') as tail_number,nullif(trim(origin_airport),'') as origin_airport,
nullif(trim(destination_airport),'') as destination_airport,
nullif(trim(scheduled_departure),'') as scheduled_departure,
nullif(trim(departure_time),'') as departure_time,nullif(trim(departure_delay),'') as departure_delay,
nullif(trim(taxi_out),'') as taxi_out,nullif(trim(wheels_off),'') as wheels_off,
nullif(trim(scheduled_time),'') as scheduled_time,nullif(trim(elapsed_time),'') as elapsed_time,
nullif(trim(air_time),'') as air_time,nullif(trim(distance),'') as distance,
nullif(trim(wheels_on),'') as wheels_on,nullif(trim(taxi_in),'') as taxi_in,
nullif(trim(scheduled_arrival),'') as scheduled_arrival,nullif(trim(arrival_time),'') as arrival_time,
nullif(trim(arrival_delay),'') as arrival_delay,nullif(trim(diverted),'') as diverted,
nullif(trim(cancelled),'') as cancelled,nullif(trim(cancellation_reason),'') as cancellation_reason,
nullif(trim(air_system_delay),'') as air_system_delay,nullif(trim(security_delay),'') as security_delay,
nullif(trim(airline_delay),'') as airline_delay,nullif(trim(late_aircraft_delay),'') as late_aircraft_delay,
nullif(trim(weather_delay),'') as weather_delay
from flights_raw)
select 'year'as category, count(*) as counts
from t
where year is null
union all 
select 'month'as category, count(*) as counts
from t
where month is null
union all 
select 'day'as category, count(*) as counts
from t
where day is null
union all 
select 'day_of_week'as category, count(*) as counts
from t
where day_of_week is null
union all 
select 'airline'as category, count(*) as counts
from t
where airline is null
union all 
select 'flight_number'as category, count(*) as counts
from t
where flight_number is null
union all 
select 'tail_number'as category, count(*) as counts
from t
where tail_number is null
union all 
select 'origin_airport'as category, count(*) as counts
from t
where origin_airport is null
union all 
select 'destination_airport'as category, count(*) as counts
from t
where destination_airport is null
union all 
select 'scheduled_departure'as category, count(*) as counts
from t
where scheduled_departure is null
union all 
select 'departure_time'as category, count(*) as counts
from t
where departure_time is null
union all 
select 'departure_delay'as category, count(*) as counts
from t
where departure_delay is null
union all 
select 'taxi_out'as category, count(*) as counts
from t
where taxi_out is null
union all 
select 'wheels_off'as category, count(*) as counts
from t
where wheels_off is null
union all 
select 'scheduled_time'as category, count(*) as counts
from t
where scheduled_time is null
union all 
select 'elapsed_time'as category, count(*) as counts
from t
where elapsed_time is null
union all 
select 'air_time'as category, count(*) as counts
from t
where air_time is null
union all 
select 'distance'as category, count(*) as counts
from t
where distance is null
union all 
select 'wheels_on'as category, count(*) as counts
from t
where wheels_on is null
union all 
select 'taxi_in'as category, count(*) as counts
from t
where taxi_in is null
union all 
select 'scheduled_arrival'as category, count(*) as counts
from t
where scheduled_arrival is null
union all 
select 'arrival_time'as category, count(*) as counts
from t
where arrival_time is null
union all 
select 'arrival_delay'as category, count(*) as counts
from t
where arrival_delay is null
union all 
select 'diverted'as category, count(*) as counts
from t
where diverted is null
union all 
select 'cancelled'as category, count(*) as counts
from t
where cancelled is null
union all 
select 'cancellation_reason'as category, count(*) as counts
from t
where cancellation_reason is null
union all 
select 'air_system_delay'as category, count(*) as counts
from t
where air_system_delay is null
union all 
select 'security_delay'as category, count(*) as counts
from t
where security_delay is null
union all 
select 'airline_delay'as category, count(*) as counts
from t
where airline_delay is null
union all
select 'late_aircraft_delay'as category, count(*) as counts
from t
where late_aircraft_delay is null
union all
select 'weather_delay'as category, count(*) as counts
from t
where weather_delay is null;

/*use null rather than empty string for missing value*/
create view clean_flight_data1 as (select nullif(trim(year),'') as year,nullif(trim(month),'') as month,
nullif(trim(day),'') as day,nullif(trim(day_of_week),'') as day_of_week,
nullif(trim(airline),'') as airline,nullif(trim(flight_number),'') as flight_number,
nullif(trim(tail_number),'') as tail_number,nullif(trim(origin_airport),'') as origin_airport,
nullif(trim(destination_airport),'') as destination_airport,
nullif(trim(scheduled_departure),'') as scheduled_departure,
nullif(trim(departure_time),'') as departure_time,nullif(trim(departure_delay),'') as departure_delay,
nullif(trim(taxi_out),'') as taxi_out,nullif(trim(wheels_off),'') as wheels_off,
nullif(trim(scheduled_time),'') as scheduled_time,nullif(trim(elapsed_time),'') as elapsed_time,
nullif(trim(air_time),'') as air_time,nullif(trim(distance),'') as distance,
nullif(trim(wheels_on),'') as wheels_on,nullif(trim(taxi_in),'') as taxi_in,
nullif(trim(scheduled_arrival),'') as scheduled_arrival,nullif(trim(arrival_time),'') as arrival_time,
nullif(trim(arrival_delay),'') as arrival_delay,nullif(trim(diverted),'') as diverted,
nullif(trim(cancelled),'') as cancelled,nullif(trim(cancellation_reason),'') as cancellation_reason,
nullif(trim(air_system_delay),'') as air_system_delay,nullif(trim(security_delay),'') as security_delay,
nullif(trim(airline_delay),'') as airline_delay,nullif(trim(late_aircraft_delay),'') as late_aircraft_delay,
nullif(trim(weather_delay),'') as weather_delay
from flights_raw);

/*create time information, standardize columns and update cancellation reason column, 
 * remove irrelevant columns
 */
create view clean_flight_data2 as (
select concat(year,'-',month,'-',day) as time,airline,flight_number,
coalesce(tail_number,'Unknown') as tail_number,origin_airport,
destination_airport,
scheduled_departure,
concat(substring(scheduled_departure,1,2),':',substring(scheduled_departure,3,4))as scheduled_departure_cleaned,
departure_time,departure_delay,taxi_out,wheels_off,
scheduled_time,elapsed_time,
air_time,distance,wheels_on,taxi_in,scheduled_arrival,
concat(substring(scheduled_arrival,1,2),':',substring(scheduled_arrival,3,4)) as scheduled_arrival_cleaned,
arrival_time,arrival_delay,diverted,
case 
	when diverted='0' then 'No'
	when diverted='1' then 'Yes'
end as diverted_cleaned,
cancelled,
case 
	when cancelled='0' then 'No'
	when cancelled='1' then 'Yes'
end as cancelled_cleaned,
cancellation_reason,
case 
	when cancellation_reason='A' then 'Airline/Carrier'
	when cancellation_reason='B' then 'Weather'
	when cancellation_reason='C' then 'National Air System'
	when cancellation_reason='D' then 'Security'
	when cancellation_reason is null and cancelled='0' and diverted='1' then 'Diverted Flight'
	when cancellation_reason is null and cancelled='0' and diverted='0' then 'Normal Flight'
end as cancellation_reason_cleaned
from clean_flight_data1);

select time,airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure_cleaned,departure_time,departure_delay,taxi_out,wheels_off,
scheduled_time,elapsed_time,air_time,distance,wheels_on,taxi_in,scheduled_arrival_cleaned,
arrival_time,arrival_delay,diverted_cleaned,cancelled_cleaned,cancellation_reason_cleaned
from clean_flight_data2;


select 'time' as category,count(*) from clean_flight_data2 where time is null union all
select 'airline' as category,count(*) from clean_flight_data2 where airline is null union all
select 'flight_number' as category,count(*) from clean_flight_data2 where flight_number is null union all
select 'tail_number' as category,count(*) from clean_flight_data2 where tail_number is null union all
select 'origin_airport' as category,count(*) from clean_flight_data2 where origin_airport is null union all
select 'destination_airport' as category,count(*) from clean_flight_data2 where destination_airport is null union all
select 'scheduled_departure_cleaned' as category,count(*) from clean_flight_data2 where scheduled_departure_cleaned is null union all
select 'departure_time' as category,count(*) from clean_flight_data2 where departure_time is null union all
select 'departure_delay' as category,count(*) from clean_flight_data2 where departure_delay is null union all
select 'taxi_out' as category,count(*) from clean_flight_data2 where taxi_out is null union all
select 'wheels_off' as category,count(*) from clean_flight_data2 where wheels_off is null union all
select 'scheduled_time' as category,count(*) from clean_flight_data2 where scheduled_time is null union all
select 'elapsed_time' as category,count(*) from clean_flight_data2 where elapsed_time is null union all
select 'air_time' as category,count(*) from clean_flight_data2 where air_time is null union all
select 'distance' as category,count(*) from clean_flight_data2 where distance is null union all
select 'wheels_on' as category,count(*) from clean_flight_data2 where wheels_on is null union all
select 'taxi_in' as category,count(*) from clean_flight_data2 where taxi_in is null union all
select 'scheduled_arrival_cleaned' as category,count(*) from clean_flight_data2 where scheduled_arrival_cleaned is null union all
select 'arrival_time' as category,count(*) from clean_flight_data2 where arrival_time is null union all
select 'arrival_delay' as category,count(*) from clean_flight_data2 where arrival_delay is null union all
select 'diverted_cleaned' as category,count(*) from clean_flight_data2 where diverted_cleaned is null union all
select 'cancelled_cleaned' as category,count(*) from clean_flight_data2 where cancelled_cleaned is null union all
select 'cancellation_reason_cleaned' as category,count(*) from clean_flight_data2 where cancellation_reason_cleaned is null;

/* Flight cancellation is the reason for rest of missing value*/
select distinct cancellation_reason_cleaned
from clean_flight_data2
where departure_time is null or departure_delay is null or taxi_out is null or
wheels_off is null or scheduled_time is null or elapsed_time is null or air_time is null or 
wheels_on is null or taxi_in is null or arrival_time is null or arrival_delay is null;

select count(*)-count(departure_time) as departure_time,
count(*)-count(departure_delay) as departure_delay,
count(*)-count(taxi_out) as taxi_out,
count(*)-count(wheels_off) as wheels_off,
count(*)-count(scheduled_time) as scheduled_time,
count(*)-count(elapsed_time) as elapsed_time,
count(*)-count(air_time) as air_time,
count(*)-count(wheels_on) as wheels_on,
count(*)-count(taxi_in) as taxi_in,
count(*)-count(arrival_time) as arrival_time,
count(*)-count(arrival_delay) as arrival_delay
from clean_flight_data2
where departure_time is null or departure_delay is null or taxi_out is null or
wheels_off is null or scheduled_time is null or elapsed_time is null or air_time is null or 
wheels_on is null or taxi_in is null or arrival_time is null or arrival_delay is null;


create view clean_flight_data3 as (
select time :: date,airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure_cleaned::time,departure_time,
concat(substring(departure_time,1,2),':',substring(departure_time,3,4))as departure_time_cleaned,
departure_delay,taxi_out,wheels_off,
concat(substring(wheels_off,1,2),':',substring(wheels_off,3,4))as wheels_off_cleaned,
scheduled_time,elapsed_time,air_time,distance,wheels_on,
concat(substring(wheels_on,1,2),':',substring(wheels_on,3,4)) as wheels_on_cleaned,
taxi_in,scheduled_arrival_cleaned::time,
arrival_time,concat(substring(arrival_time,1,2),':',substring(arrival_time,3,4))as arrival_time_cleaned,
arrival_delay,diverted_cleaned,cancelled_cleaned,cancellation_reason_cleaned
from clean_flight_data2);

/* correct the time information*/
create view clean_flight_data4 as (
select time,airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure_cleaned,departure_time,departure_time_cleaned,
case 
	when departure_time is null then null 
	when departure_time is not null then departure_time_cleaned
end departure_time_cleaned2,departure_delay,
taxi_out,wheels_off,wheels_off_cleaned,
case 
	when wheels_off is null then null 
	when wheels_off is not null then wheels_off_cleaned
end as wheels_off_cleaned2,
scheduled_time,elapsed_time,air_time,distance,wheels_on,wheels_on_cleaned,
case
	when wheels_on is null then null
	when wheels_on is not null then wheels_on_cleaned
end as wheels_on_cleaned2,
taxi_in,scheduled_arrival_cleaned,
arrival_time,arrival_time_cleaned,
case
	when arrival_time is null then null
	when arrival_time is not null then arrival_time_cleaned
end as arrival_time_cleaned2,
arrival_delay,diverted_cleaned,cancelled_cleaned,cancellation_reason_cleaned 
from clean_flight_data3);

select time,airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure_cleaned,departure_time_cleaned2,departure_delay,taxi_out,wheels_off_cleaned2,
scheduled_time,elapsed_time,air_time,distance,wheels_on_cleaned2,taxi_in,
scheduled_arrival_cleaned,arrival_time_cleaned2,arrival_delay,diverted_cleaned,
cancelled_cleaned,cancellation_reason_cleaned
from clean_flight_data4;

select 'time' as category, count(*) from clean_flight_data4 where time is null union all
select 'airline' as category, count(*) from clean_flight_data4 where airline is null union all
select 'flight_number' as category, count(*) from clean_flight_data4 where flight_number is null union all
select 'tail_number' as category, count(*) from clean_flight_data4 where tail_number is null union all
select 'origin_airport' as category, count(*) from clean_flight_data4 where origin_airport is null union all
select 'destination_airport' as category, count(*) from clean_flight_data4 where destination_airport is null union all
select 'scheduled_departure_cleaned' as category, count(*) from clean_flight_data4 where scheduled_departure_cleaned is null union all
select 'departure_time_cleaned2' as category, count(*) from clean_flight_data4 where departure_time_cleaned2 is null union all
select 'departure_delay' as category, count(*) from clean_flight_data4 where departure_delay is null union all
select 'taxi_out' as category, count(*) from clean_flight_data4 where taxi_out is null union all
select 'wheels_off_cleaned2' as category, count(*) from clean_flight_data4 where wheels_off_cleaned2 is null union all
select 'scheduled_time' as category, count(*) from clean_flight_data4 where scheduled_time is null union all
select 'elapsed_time' as category, count(*) from clean_flight_data4 where elapsed_time is null union all
select 'air_time' as category, count(*) from clean_flight_data4 where air_time is null union all
select 'distance' as category, count(*) from clean_flight_data4 where distance is null union all
select 'wheels_on_cleaned2' as category, count(*) from clean_flight_data4 where wheels_on_cleaned2 is null union all
select 'taxi_in' as category, count(*) from clean_flight_data4 where taxi_in is null union all
select 'scheduled_arrival_cleaned' as category, count(*) from clean_flight_data4 where scheduled_arrival_cleaned is null union all
select 'arrival_time_cleaned2' as category, count(*) from clean_flight_data4 where arrival_time_cleaned2 is null union all
select 'arrival_delay' as category, count(*) from clean_flight_data4 where arrival_delay is null union all
select 'diverted_cleaned' as category, count(*) from clean_flight_data4 where diverted_cleaned is null union all
select 'cancelled_cleaned' as category, count(*) from clean_flight_data4 where cancelled_cleaned is null union all
select 'cancellation_reason_cleaned' as category, count(*) from clean_flight_data4 where cancellation_reason_cleaned is null;

create view clean_flight_data5 as(
select time,airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure_cleaned as scheduled_departure,
departure_time_cleaned2 ::time as departure_time,departure_delay,taxi_out,
wheels_off_cleaned2 :: time as wheels_off,
scheduled_time,elapsed_time,air_time,distance,
wheels_on_cleaned2:: time as wheels_on,taxi_in,
scheduled_arrival_cleaned as scheduled_arrival,
arrival_time_cleaned2 :: time as arrival_time,arrival_delay,
diverted_cleaned,cancelled_cleaned,cancellation_reason_cleaned
from clean_flight_data4);

/* Confirm numeric data are integers*/
select 'departure_delay' as category, count(*)
from clean_flight_data5
where departure_delay like '%.%'
union all
select 'taxi_out' as category, count(*)
from clean_flight_data5
where taxi_out like '%.%'
union all
select 'scheduled_time' as category, count(*)
from clean_flight_data5
where scheduled_time like '%.%'
union all
select 'elapsed_time' as category, count(*)
from clean_flight_data5
where elapsed_time like '%.%'
union all
select 'air_time' as category, count(*)
from clean_flight_data5
where air_time like '%.%'
union all
select 'distance' as category, count(*)
from clean_flight_data5
where distance like '%.%'
union all
select 'taxi_in' as category, count(*)
from clean_flight_data5
where taxi_in like '%.%'
union all
select 'arrival_delay' as category, count(*)
from clean_flight_data5
where arrival_delay like '%.%';

/*correct data_type*/
create view cleaned_flight_data as (
select time,airline as iata_code_airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure,departure_time,departure_delay::int,taxi_out::int,wheels_off,
scheduled_time::int,elapsed_time::int,air_time::int,distance::int,wheels_on,taxi_in::int,
scheduled_arrival,arrival_time,arrival_delay::int,diverted_cleaned as diverted,cancelled_cleaned as cancelled,
cancellation_reason_cleaned as cancellation_reason
from clean_flight_data5);

select count(*) as clean_data_rows, (select count(*) from flights_raw) as raw_data_rows
from cleaned_flight_data;

/*save cleaned data into a table*/
create table flights_cleaned(
flights_cleaned_id int generated always as identity constraint flights_cleaned_id_pk primary key,
time date,
iata_code_airline varchar(30),
flight_number varchar(30),
tail_number varchar(30),
origin_airport varchar(30),
destination_airport varchar(30),
scheduled_departure time,
departure_time time,
departure_delay int,
taxi_out int,
wheels_off time,
scheduled_time int,
elapsed_time int,
air_time int,
distance int,
wheels_on time,
taxi_in int,
scheduled_arrival time,
arrival_time time,
arrival_delay int,
diverted varchar(30),
cancelled varchar(30),
cancellation_reason varchar(30));

insert into flights_cleaned (time,iata_code_airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure,departure_time,departure_delay,taxi_out,wheels_off,scheduled_time,
elapsed_time,air_time,distance,wheels_on,taxi_in,scheduled_arrival,arrival_time,arrival_delay,
diverted,cancelled,cancellation_reason)
select time,iata_code_airline,flight_number,tail_number,origin_airport,destination_airport,
scheduled_departure,departure_time,departure_delay,taxi_out,wheels_off,scheduled_time,
elapsed_time,air_time,distance,wheels_on,taxi_in,scheduled_arrival,arrival_time,arrival_delay,
diverted,cancelled,cancellation_reason
from cleaned_flight_data;


select count(*) as clean_data_rows, (select count(*) from flights_raw) as raw_data_rows,
(select count(*) from flights_cleaned) as flights_cleaned_rows
from cleaned_flight_data;

/* Becuase same scheduled flight mihgt refer to different airport, it might a data entry issue if the airports are in numbers,
 * but there are valid airport entry and the information is different, therefore Flight information will connect to flight table directly*/
with t as (select distinct iata_code_airline,flight_number,scheduled_departure,scheduled_arrival,scheduled_time,
origin_airport,destination_airport
from flights_cleaned),
t2 as (select concat(iata_code_airline,flight_number,scheduled_departure,scheduled_arrival,scheduled_time) as group_info,
concat(origin_airport,destination_airport) as airport
from t),
t3 as (select group_info, airport,
row_number() over(partition by group_info order by airport) as ranking
from t2)
select group_info, airport,ranking
from t3
where group_info='AA100220:05:0022:24:00199';


/* Clean the data for flight information table that contains origin_airport 
destination_airport and distance*/
create view airports_distance as (select distinct origin_airport,destination_airport,distance
from flights_cleaned);
create view airports as (select distinct origin_airport,destination_airport
from flights_cleaned);

select count(*)as airports_count, (select count(*) from airports_distance) as airports_distance_count,
(select count(*) from airports_distance)-count(*) as repeated_distance_value_count
from airports;
with t as (select origin_airport,destination_airport,distance,
row_number() over(partition by origin_airport,destination_airport order by distance) as ranking
from airports_distance)
select max(ranking) as max_ranking
from t;
/*
the max(ranking) is two so we know only few origin destination airpot distance combination are not 
unique the distance have two difference values instead of one*/
with t as (select origin_airport,destination_airport,distance, 
lead(distance) over (partition by origin_airport,destination_airport order by distance) as max_distance
from airports_distance),
t2 as (select origin_airport,destination_airport,distance,max_distance
from t
where max_distance is not null),
t3 as (select origin_airport,destination_airport,distance,max_distance,(max_distance-distance) as distance_difference
from t2)
select max(distance_difference) max_distance_difference
from t3;
/* 
select count(*)
from t2;
We find those 68 records and we confirm the maximum distance difference is 2 
so we will not treat them as unique value*/

/* Prepare table for flight information and flight schedule*/
create view flight_information_view as (select distinct origin_airport, destination_airport, distance
from cleaned_flight_data);
create view flight_schedule_view as (select distinct iata_code_airline,flight_number, scheduled_departure, scheduled_arrival, scheduled_time
from cleaned_flight_data);


create table flight_information(
flight_information_id int generated always as identity constraint flight_information_id_pk primary key,
distance int not null,
origin_airport_id int not null,
destination_airport_id int not null,
flight_information varchar(1000) not null,
constraint fk_origin_airport_id foreign key (origin_airport_id) references us_airport(airport_id),
constraint fk_destination_airport_id foreign key (destination_airport_id) references us_airport(airport_id));
insert into flight_information(origin_airport_id, destination_airport_id, distance,flight_information)
with t as (select origin_airport, destination_airport, distance,
row_number() over(partition by origin_airport, destination_airport order by distance) as ranking
from flight_information_view),
t2 as (select origin_airport, destination_airport, distance,
concat(origin_airport, destination_airport) as flight_information
from t
where ranking=1),
t3 as (select t2.origin_airport,u1.iata_code_airport,u1.airport_id,
case
	when u1.iata_code_airport is not null then u1.airport_id
	when u1.iata_code_airport is null then 1
end as origin_airport_id,
t2.destination_airport,u2.iata_code_airport,u2.airport_id,
case
	when u2.iata_code_airport is not null then u2.airport_id
	when u2.iata_code_airport is null then 1
end as destination_airport_id,
t2.distance,t2.flight_information
from t2
left join us_airport u1
on t2.origin_airport=u1.iata_code_airport
left join us_airport u2
on t2.destination_airport=u2.iata_code_airport)
select origin_airport_id,destination_airport_id,distance,flight_information
from t3;

create table flight_schedule(
flight_schedule_id int generated always as identity constraint flights_schedule_pk primary key,
iata_code_airline varchar(2) not null,
flight_number varchar(30) not null,
scheduled_departure time not null,
scheduled_arrival time not null,
scheduled_time int,
flight_schedule varchar(1000) not null,
constraint fk_iata_code_airline foreign key (iata_code_airline) references us_airline(iata_code_airline));
insert into flight_schedule(iata_code_airline,flight_number,
scheduled_departure,scheduled_arrival,scheduled_time,flight_schedule)
select iata_code_airline,flight_number, scheduled_departure, scheduled_arrival, scheduled_time,
concat(iata_code_airline,flight_number, scheduled_departure, scheduled_arrival, scheduled_time) as flight_schedule
from flight_schedule_view;


/*Create Flights table*/
create view flight_view as (select time as calendar_date,tail_number,departure_time,departure_delay,
taxi_out,wheels_off,elapsed_time,air_time,wheels_on,taxi_in,arrival_time,arrival_delay,
diverted,cancelled,cancellation_reason,
concat(origin_airport, destination_airport) as flight_information,
concat(iata_code_airline,flight_number, scheduled_departure, scheduled_arrival, 
scheduled_time) as flight_schedule
from flights_cleaned);

/*check the row counts*/
select count(*)
from flight_view f
join flight_information fi
on f.flight_information=fi.flight_information
join flight_schedule fs
on f.flight_schedule=fs.flight_schedule;


create table flight(
flight_id int generated always as identity constraint flight_id_pk primary key,
calendar_date date not null,
tail_number varchar(30) not null,
departure_time time,
departure_delay int,
taxi_out int,
wheels_off time,
elapsed_time int,
air_time int,
wheels_on time,
taxi_in int,
arrival_time time,
arrival_delay int,
diverted varchar(30) not null,
cancelled varchar(30)not null,
cancellation_reason varchar(30) not null,
flight_information_id int not null,
flight_schedule_id int not null,
constraint fk_flight_information_id foreign key (flight_information_id) references flight_information (flight_information_id),
constraint fk_flight_schedule_id foreign key (flight_schedule_id) references flight_schedule (flight_schedule_id));
insert into flight(calendar_date,tail_number,departure_time,departure_delay,
taxi_out,wheels_off,elapsed_time,air_time,wheels_on,taxi_in,arrival_time,arrival_delay,
diverted,cancelled,cancellation_reason,flight_information_id,flight_schedule_id)
select calendar_date,tail_number,departure_time,departure_delay,
taxi_out,wheels_off,elapsed_time,air_time,wheels_on,taxi_in,arrival_time,arrival_delay,
diverted,cancelled,cancellation_reason,flight_information_id,flight_schedule_id
from flight_view f
join flight_information fi
on f.flight_information=fi.flight_information
join flight_schedule fs
on f.flight_schedule=fs.flight_schedule;

/* check the count again and remove flight_information and flight_schedule column*/
select count(*) as final_database_count, (select count(*) from flights_raw) as raw_data_count
from flight f
join flight_information fi
on f.flight_information_id=fi.flight_information_id 
join flight_schedule ft
on f.flight_schedule_id=ft.flight_schedule_id
join us_airport ua1
on fi.destination_airport_id=ua1.airport_id
join us_airport ua2
on fi.origin_airport_id=ua2.airport_id
join us_airline usair
on ft.iata_code_airline=usair.iata_code_airline;

alter table flight_information 
drop column flight_information;
alter table flight_schedule 
drop column flight_schedule;