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
  def get_forecast
    forecast = Rails.cache.read("/forecast/#{@geocoded_address.postal_code}") if @geocoded_address.postal_code
    @cached = true if forecast
    if !@cached
      openweather_client = Client::OpenWeatherClient.new
      forecast = format_forecast(openweather_client.get_weather_for_address(@geocoded_address))
      if @geocoded_address.postal_code
        Rails.cache.write("/forecast/#{@geocoded_address.postal_code}", forecast, expires_in: 30.minutes)
      end
    end
    @current = forecast['current']
    @daily = forecast['daily'] 
    return self
  end

  def format_forecast(result)
    result['daily'].each_with_index do |daily_forecast, i|
      daily_time = Time.at(daily_forecast['dt']).localtime.to_datetime.strftime('%A %B %d')
      result['daily'][i]['day'] = Time.at(daily_forecast['dt']).localtime.to_datetime.strftime('%A %B %d')
    end
    return result
  end
end