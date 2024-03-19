class Client::OpenWeatherClient

  OPEN_WEATHER_ENDPOINT = 'https://api.openweathermap.org/data/3.0/onecall'
  OPEN_WEATHER_API_KEY = '9a22a4c62a72679c1bcb33d54c02d33e'

  def get_weather_for_address(address)
    uri = URI(OPEN_WEATHER_ENDPOINT)
    params = { 
      :lat => address.latitude,
      :lon => address.longitude,
      :exclude => 'minutely,hourly',
      :units => 'imperial',
      :appid => OPEN_WEATHER_API_KEY 
    }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    raise "Bad response code: #{res.code}" unless res.is_a?(Net::HTTPSuccess)
    return JSON.parse(res.body)
  end
end