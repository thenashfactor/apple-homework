require 'test_helper'

# Tests forecast response as well as caching logic (cached for 30 minutes by postal code)
class ForecastTest < ActiveSupport::TestCase
  test 'forecast uncached and cached' do
    expected_forecast_current = {
      'dt' => 1_710_880_364,
      'temp' => 40.86,
      'feels_like' => 32,
      'humidity' => 54,
      'wind_speed' => 18.41,
      'weather' => [{ 'id' => 804, 'main' => 'Clouds', 'description' => 'overcast clouds', 'icon' => '04d' }]
    }
    expected_forecast_daily = [{
      'dt' => 1_710_867_600,
      'summary' => 'Expect a day of partly cloudy with clear spells',
      'temp' => { 'day' => 38.97, 'min' => 28.47, 'max' => 41.2, 'night' => 32.59, 'eve' => 40.75, 'morn' => 31.68 },
      'humidity' => 49,
      'wind_speed' => 23.24,
      'day' => 'Tuesday March 19'
    }]

    forecast = Forecast.new('New York, NY')
    forecast_result = forecast.forecast
    assert forecast_result.current == expected_forecast_current
    assert forecast_result.daily == expected_forecast_daily
    assert !forecast_result.cached

    forecast_result = forecast.forecast
    assert forecast_result.current == expected_forecast_current
    assert forecast_result.daily == expected_forecast_daily
    assert forecast_result.cached
  end
end
