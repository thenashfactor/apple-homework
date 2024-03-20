class Client::OpenWeatherClient

  OPEN_WEATHER_ONECALL_ENDPOINT = 'https://api.openweathermap.org/data/3.0/onecall'
  OPEN_WEATHER_API_KEY = '9a22a4c62a72679c1bcb33d54c02d33e'

  def get_weather_for_address(geocoded_address)
    begin
      uri = URI(OPEN_WEATHER_ONECALL_ENDPOINT)
      params = { 
        :lat => geocoded_address.latitude,
        :lon => geocoded_address.longitude,
        :exclude => 'minutely,hourly',
        :units => 'imperial',
        :appid => OPEN_WEATHER_API_KEY 
      }
      result_json = http_get(uri, params)
      raise "Error response: #{result_json['cod']}, #{result_json['message']}" if result_json['cod']
    rescue => e
      raise "OpenWeatherClient: #{e.to_s}"
    end
    return result_json
  end

  def http_get(uri, params = {})
    uri.query = URI.encode_www_form(params)
    result = Net::HTTP.get_response(uri)
    return JSON.parse(result.body)
  end
end


