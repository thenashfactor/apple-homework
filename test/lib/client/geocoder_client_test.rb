require 'test_helper'

# Geocoder stubs are defined in test_helper
class GeocoderClientTest < ActiveSupport::TestCase

  setup do
    @geocoder_client = Client::GeocoderClient.new
  end

  test 'geocode success' do
    geocoded_address = @geocoder_client.geocode('New York, NY') # stubbed in test_helper.rb
    assert geocoded_address.address == 'New York, NY, USA'
  end

  test 'geocode raises Timeout::Error' do
    Client::GeocoderClient.any_instance.expects(:geocode).raises(Timeout::Error)
    assert_raises(Timeout::Error) do
      @geocoder_client.geocode('New York, NY')
    end
  end
end