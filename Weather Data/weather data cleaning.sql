/*Clean weather data and create database to store it*/

/* Verify Weather data and create tables*/
create table weather_code(
weather_code int constraint weather_code_pk primary key,
description varchar(60) not null);

create table units(
unit_id int constraint unit_id_pk primary key,
time_format varchar(20),
weather_code varchar(20),
temperature_2m_max varchar(2),
temperature_2m_min varchar(2),
precipitation_sum varchar(10),
snowfall_sum varchar(10),
wind_speed_10m_max varchar(10)
);


create table daily_data(
time varchar(60) not null,
weather_code varchar(60) not null,
temperature_2m_max varchar(60) not null,
temperature_2m_min varchar(60) not null,
precipitation_sum varchar(60) not null,
snowfall_sum varchar(60) not null,
wind_speed_10m_max varchar(60) not null,
airport	varchar(60) not null,
unit_id varchar(60) not null
);

/*Verify return data has correct number of records*/
select count(*) as number_of_records,date '2015-02-05'- date'2015-01-21'+1 as expected_records
from daily_data;

create table weather(
weather_id int generated always as identity constraint weather_id_pk primary key,
calendar_date date not null,
weather_code int not null,
temperature_2m_max numeric(6,2) not null,
temperature_2m_min numeric(6,2) not null,
precipitation_sum numeric(6,2) not null,
snowfall_sum numeric(6,2) not null,
wind_speed_10m_max numeric(6,2) not null,
airport_id int not null,
unit_id int not null,
constraint fk_airport_id foreign key (airport_id) references us_airport(airport_id),
constraint fk_unit_id foreign key (unit_id) references units(unit_id),
constraint fk_weather_code foreign key (weather_code) references weather_code(weather_code));

/* Correct data type for return data*/
create view cleaned_weather_data as
select time::date as calendar_date,weather_code::int,temperature_2m_max::numeric,temperature_2m_min::numeric,
precipitation_sum::numeric,snowfall_sum::numeric,wind_speed_10m_max::numeric,
(select airport_id from us_airport ua where d.airport=ua.iata_code_airport) as airport_id,
unit_id::int
from daily_data d;

insert into weather(calendar_date,weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,
snowfall_sum,wind_speed_10m_max,airport_id,unit_id)
select *
from cleaned_weather_data;

/*Verify number of records in final table*/
select count(*) as number_of_records,date '2015-02-05'- date'2015-01-21'+1 as expected_records
from weather;

select count(*) as number_of_records,date '2015-02-05'- date'2015-01-21'+1 as expected_records
from weather w
join weather_code wc 
on w.weather_code=wc.weather_code
join units u
on w.unit_id=u.unit_id
join us_airport ua
on ua.airport_id=w.airport_id;