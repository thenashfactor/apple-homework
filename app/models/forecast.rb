class Forecast 
  include ActiveModel::API

  attr_reader :address, :current, :daily, :cached

  def initialize(address)
    @address = address
    @cached = false
    @current = nil
    @daily = nil
  end

  # Forecast is cached for 30 mins
  def get_forecast
    client = Client::OpenWeatherClient.new
    formatted_forecast = Rails.cache.read("/forecast/#{address.postal_code}")
    if formatted_forecast
      @cached = true
    else
      # Cache forecast for 30 mins
      formatted_forecast = format_forecast(client.get_weather_for_address(address))
      Rails.cache.write("/forecast/#{address.postal_code}", formatted_forecast, expires_in: 30.minutes)
    end
    pp formatted_forecast
    @current = formatted_forecast['current']
    @daily = formatted_forecast['daily'] 
    return self
  end

  def format_forecast(result)
    result['current']['day'] = 'Today'
    result['daily'][0]['day'] = 'Today'
    result['daily'].each_with_index do |daily_forecast, i|
      result['daily'][i]['day'] = Time.at(daily_forecast['dt']).utc.to_datetime.strftime('%A %B %d')
    end
    return result
  end
end