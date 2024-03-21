# Retrieves and formats OpenWeather API current and daily forecasts
class Forecast
  include ActiveModel::API

  attr_reader :geocoded_address, :current, :daily, :cached

  def initialize(raw_address)
    @geocoded_address = Client::GeocoderClient.new.geocode(raw_address)
    @current = nil
    @daily = nil
    @cached = false
  end

  # Forecast is cached for 30 mins
  # Caching scheme is based on postal_code
  def forecast
    forecast = Rails.cache.read("/forecast/#{@geocoded_address.postal_code}") if @geocoded_address.postal_code
    @cached = true if forecast
    forecast = cache_forecast unless @cached
    @current = forecast['current']
    @daily = forecast['daily']
    self
  end

  # Cache the forecast by postal_code
  # Will not cache forecast if postal_code is missing
  def cache_forecast
    openweather_client = Client::OpenWeatherClient.new
    forecast = format_forecast(openweather_client.forecast_for_address(@geocoded_address))
    if @geocoded_address.postal_code
      Rails.cache.write("/forecast/#{@geocoded_address.postal_code}", forecast, expires_in: 30.minutes)
    end
    return forecast
  end

  # Changes daily epoch timestamp into a human-readable date
  def format_forecast(result)
    result['daily'].each_with_index do |daily_forecast, i|
      result['daily'][i]['day'] = Time.at(daily_forecast['dt']).localtime.to_datetime.strftime('%A %B %d')
    end
    result
  end
end
