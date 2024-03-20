# apple-homework
## Forecast Assignment

This application allows a user to input an address for geocoding on the landing page. The 
geocoded address is then used to retrieve current and daily forecasts (next seven days) from the [OpenWeather
One Call API](https://openweathermap.org/api/one-call-3).

## Object Decomposition

GeocoderClient - Takes a raw address as input and leverages the Ruby geocoder gem to normalize the address. 
The geocoded address is returned as a Geocoder::Result object.

Every Geocoder::Result object exposes the following attributes:

latitude - float
longitude - float
coordinates - array of the above two in the form of [lat,lon]
address - string
city - string
state - string
state_code - string
postal_code - string
country - string
country_code - string

These attributes are populated whenever available. Inputting an address like 'New York, NY' will not populate postal_code because the address resolution is not granular enough to determine the associated postal_code. country_code
is optional and defaults to 'US'.

OpenWeatherClient - 

Forecast - Initialized with raw address from the input on the index page. The address is geocoded when the forecast method is called. OpenWeatherClient is leveraged to make an API call to retrieve the current and daily forecasts  


