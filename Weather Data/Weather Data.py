# Retrieved historical weather data from the Open-Meteo Historical Weather API
import pandas as pd
import requests
import time


airports={'ORD':{'latitude':41.97694,'longitude':-87.90815}}

for airport in airports:
  print('airport:',airport)
  attempt=0
  url='https://archive-api.open-meteo.com/v1/archive'
  params={'latitude':airports[airport]['latitude'],'longitude':airports[airport]['longitude'],'start_date':'2015-01-21','end_date':'2015-02-05','timezone':'auto',
          'daily':'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,snowfall_sum,wind_speed_10m_max'}

  response=None
  
  # Retrieve data from the REST API
  try:
    while attempt<=3:
      response=requests.get(url=url,params=params,timeout=10)
      if response.status_code==200:
        #print('Good request')
        break
      elif response.status_code in (408, 429, 500, 502, 503, 504):
          attempt=attempt+1
          if attempt<=3:
            print(f'Error, conduct retry attempts {attempt}, total attempts {attempt+1}')
            time.sleep(2**attempt)
          else:
            continue
      else:
        raise Exception('Bad Request, no retry conducted')
  except requests.ConnectionError:
    raise Exception('Connection error')
  except requests.Timeout:
    raise Exception('Time out')
  except requests.RequestException:
    raise Exception('Error')

  # Verify Returned Data
  if response.status_code==200:
     print('Request is valid')
     try:
        data=response.json()
        #print(data)
     except requests.JSONDecodeError:
        raise Exception('Invalid return Data')
  else:
     raise Exception('Bad Request, All three retry attempts failed')

  # Converted Return Data into Pandas DataFrame
  unit=None
  latitude=None 
  longitude=None
  daily=None
  for i in data.keys():
      if i in ('generationtime_ms','utc_offset_seconds','timezone','elevation'):
           continue
      elif i =='latitude':
           latitude=data[i]
      elif i=='longitude':
           longitude=data[i]
      elif i == 'daily_units':
           if type(data[i])==dict:
              unit=data[i]
           else:
              raise Exception('Unsupport Data Type')
      elif i=='daily':
           #print(i)
           length=None
           if type(data[i])==dict:
              for key in data[i].keys():
                #print(key)
                #print(data[i][key])
                if length is None:
                  length=len(data[i][key])
                  #print(length)
                else:
                    if length!=len(data[i][key]):
                      raise Exception ('Data is missing')
              print('Daily Data is valid')
              daily=data[i]
  units=pd.DataFrame(unit,index=[0])
  units['unit_id']=1
  units=units.drop_duplicates()
  if units.isna().sum().sum()==0:
     #print('No missing value for units data')
     print(units)
  else:
    raise Exception ('Missing value in units data')
  daily_data=pd.DataFrame(daily)
  daily_data['airport']=airport
  daily_data=daily_data.drop_duplicates()
  if daily_data.isna().sum().sum()==0:
     #print('No missing value for daily data')
     print(daily_data)
  else:
    raise Exception('Missing value in daily data')
  units.to_csv('units.csv',index=False)
  daily_data.to_csv('daily_data.csv',index=False)