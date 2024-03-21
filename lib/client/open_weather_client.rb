# Uses OpenWeather One Call API client to retrieve weather forecast
# by passing in latitude and longitude.
# See https://openweathermap.org/api/one-call-3 for more detail

module Client
  class OpenWeatherClient
    OPEN_WEATHER_ONECALL_ENDPOINT = 'https://api.openweathermap.org/data/3.0/onecall'.freeze
    OPEN_WEATHER_API_KEY = '9a22a4c62a72679c1bcb33d54c02d33e'.freeze

    def forecast_for_address(geocoded_address)
      begin
        uri = URI(OPEN_WEATHER_ONECALL_ENDPOINT)
        params = {
          lat: geocoded_address.latitude,
          lon: geocoded_address.longitude,
          exclude: 'minutely,hourly',
          units: 'imperial',
          appid: OPEN_WEATHER_API_KEY
        }
        result_json = http_get(uri, params)
        # Rather than throwing an exception, the result json will contain an error code and message
        # Raise an exception containing the details so it bubbles to the top
        raise "Error response: #{result_json['cod']}, #{result_json['message']}" if result_json['cod']
      rescue StandardError => e
        raise "OpenWeatherClient: #{e}"
      end
      result_json
    end

    # Wraps Net::HTTP get logic
    def http_get(uri, params = {})
      uri.query = URI.encode_www_form(params)
      result = Net::HTTP.get_response(uri)
      JSON.parse(result.body)
    end
  end
end
