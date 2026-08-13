/* Create Flat table for analysis */
create view flight_database_view as (
select f.flight_id, ual.airline,f.calendar_date,f.tail_number,f.departure_time,
f.departure_delay, f.taxi_out,f.wheels_off,f.elapsed_time,f.air_time,f.wheels_on,f.taxi_in,
f.arrival_time,f.arrival_delay,f.diverted,f.cancelled,f.cancellation_reason,
fi.distance,uao.iata_code_airport as origin_airport_code, uao.airport as origin_airport,
uao.city as origin_city, uao.state as origin_state,uao.latitude as origin_latitude,
uao.longitude as origin_longitude,uad.iata_code_airport as destination_airport_code,
uad.airport as destination_airport, uad.city as destination_city, uad.state as destination_state,
uad.latitude as destination_latitude, uad.longitude as destination_longitude,
fs.iata_code_airline, fs.flight_number,fs.scheduled_departure,fs.scheduled_arrival,fs.scheduled_time
from flight f
join flight_information fi
on f.flight_information_id=fi.flight_information_id 
join flight_schedule fs 
on f.flight_schedule_id=fs.flight_schedule_id
join us_airline ual
on fs.iata_code_airline=ual.iata_code_airline
join us_airport uao 
on fi.origin_airport_id=uao.airport_id
join us_airport uad 
on fi.destination_airport_id=uad.airport_id);