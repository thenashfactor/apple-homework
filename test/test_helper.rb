ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'geocoder'
require 'mocha/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    WebMock.disable_net_connect!
    Geocoder.configure(lookup: :test, ip_lookup: :test)
    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'coordinates' => [40.7143528, -74.0059731],
          'address' => 'New York, NY, USA',
          'state' => 'New York',
          'state_code' => 'NY',
          'postal_code' => '10007',
          'country' => 'United States',
          'country_code' => 'US'
        }
      ]
    )

    OPEN_WEATHER_ONECALL_ENDPOINT = 'https://api.openweathermap.org/data/3.0/onecall'
    setup do
      # OpenWeather response stub

      successful_response = {
        'current' => {
          'dt' => 1_710_880_364,
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
            'temp' => { 'day' => 38.97, 'min' => 28.47, 'max' => 41.2, 'night' => 32.59, 'eve' => 40.75,
                        'morn' => 31.68 },
            'humidity' => 49,
            'wind_speed' => 23.24
          }
        ]
      }.to_json

      WebMock.stub_request(:get, OPEN_WEATHER_ONECALL_ENDPOINT)
             .with(
               query: hash_including({}),
               headers: {
                 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'Host' => 'api.openweathermap.org',
                 'User-Agent' => 'Ruby'
               }
             )
             .to_return(status: 200, body: successful_response, headers: {})

      Rails.cache.clear
    end
  end
end
