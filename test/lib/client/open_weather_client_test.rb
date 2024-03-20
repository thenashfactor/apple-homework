require 'test_helper'

# Geocoder stubs are defined in test_helper
class OpenWeatherClientTest < ActiveSupport::TestCase
  setup do
    @geocoder_client = Client::GeocoderClient.new
    @openweather_client = Client::OpenWeatherClient.new
  end

  test 'get_weather_for_address success' do
    geocoded_address = @geocoder_client.geocode('New York, NY') # stubbed in test_helper.rb
    @openweather_client.get_weather_for_address(geocoded_address)
  end

  test 'get_weather_for_address error' do
    error_response = {
      "cod"=> 400,
      "message"=> "Invalid date format",
      "parameters"=> [
          "date"
      ]
    }.to_json
    stub_request(:get, OPEN_WEATHER_ONECALL_ENDPOINT).
      with(
        query: hash_including({}),
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host'=>'api.openweathermap.org',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 400, body: error_response, headers: {})
    geocoded_address = @geocoder_client.geocode('New York, NY') # no stub defined for 'foo' 
    error = assert_raises(StandardError) do
      @openweather_client.get_weather_for_address(geocoded_address)
    end
    assert_equal 'OpenWeatherClient: Error response: 400, Invalid date format', error.message
  end
end