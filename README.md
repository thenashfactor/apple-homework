# apple-homework

## Forecast Assignment

This application allows a user to input an address for geocoding on the landing page. The 
geocoded address is then used to retrieve current and daily forecasts (next seven days) from the [OpenWeather
One Call API](https://openweathermap.org/api/one-call-3).

## Object Decomposition

### GeocoderClient 

Takes a raw address as input and leverages the Ruby geocoder gem to normalize the address.
The geocoded address is returned as a *Geocoder::Result* object.

Every *Geocoder::Result* object exposes the following attributes:

- latitude - float
- longitude - float
- coordinates - array of the above two in the form of [lat,lon]
- address - string
- city - string
- state - string
- state_code - string
- postal_code - string
- country - string
- country_code - string - optional, defaults to 'US' unless specified after the last comma in the raw address input

These attributes are populated whenever available. Inputting an address like 'New York, NY' will not populate postal_code because the address resolution is not granular enough to determine the associated postal_code. country_code
is optional and defaults to 'US'.

#### Methods

`geocode`
- input: *raw address* - string
- output: *Geocoder::Result* - object

### OpenWeatherClient

Uses the [OpenWeather One Call API](https://openweathermap.org/api/one-call-3) to retrieve current and daily forecasts.
Daily forecasts are available for the current day and seven days afterward.

#### Methods

`forecast_for_address`
- input:  *Geocoder::Result object*
- output: *Hash*, see Sample Response below

#### Sample Response
```
{
  'current' => {
    'dt' => 1710880364,
    'temp' => 40.86,
    'feels_like' => 32,
    'humidity' => 54,
    'wind_speed' => 18.41,
    'weather' => [{ 'id' => 804, 'main' => 'Clouds', 'description' => 'overcast clouds', 'icon' => '04d' }]
  },
  'daily' => [
    {
      'dt' => 1_710_867_600,
      'summary' => 'Expect a day of partly cloudy with clear spells',
      'temp' => { 'day' => 38.97, 'min' => 28.47, 'max' => 41.2,
        'night' => 32.59, 'eve' => 40.75, 'morn' => 31.68 },
      'humidity' => 49,
      'wind_speed' => 23.24
    }
    ...
  ]
}
```

### Forecast 

Forecast objects are initialized with a raw address. The raw address is geocoded on initialization and passed into the OpenWeatherClient.forecast_for_address method. This method is leveraged to make an API call to retrieve the current and daily forecasts and return a populated Forecast object. 

#### Methods

`forecast`
- input:  *raw address* - string
- output: *Forecast* - object

#### Sample Response

```
#<Forecast:0x000000012a4fe1a8
 @cached=false,
 @current=
  {"dt"=>1710985506,
   "sunrise"=>1710934684,
   "sunset"=>1710978481,
   "temp"=>24.19,
   "feels_like"=>11.61,
   "pressure"=>1017,
   "humidity"=>55,
   "dew_point"=>11.86,
   "uvi"=>0,
   "clouds"=>75,
   "visibility"=>10000,
   "wind_speed"=>14.97,
   "wind_deg"=>320,
   "weather"=>[{"id"=>803, "main"=>"Clouds", "description"=>"broken clouds", "icon"=>"04n"}]},
 @daily=
  [{"dt"=>1710954000,
    "sunrise"=>1710934684,
    "sunset"=>1710978481,
    "moonrise"=>1710962160,
    "moonset"=>1710928860,
    "moon_phase"=>0.36,
    "summary"=>"There will be partly cloudy today",
    "temp"=>{"day"=>30.22, "min"=>23.86, "max"=>33.04, "night"=>23.86, "eve"=>25.72, "morn"=>28.06},
    "feels_like"=>{"day"=>17.62, "night"=>12.27, "eve"=>13.12, "morn"=>17.15},
    "pressure"=>1013,
    "humidity"=>35,
    "dew_point"=>5.9,
    "wind_speed"=>21.47,
    "wind_deg"=>313,
    "wind_gust"=>28.52,
    "weather"=>[{"id"=>803, "main"=>"Clouds", "description"=>"broken clouds", "icon"=>"04d"}],
    "clouds"=>75,
    "pop"=>0.15,
    "uvi"=>2.8,
    "day"=>"Wednesday March 20"},
    ...
  ]
```