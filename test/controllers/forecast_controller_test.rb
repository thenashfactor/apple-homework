require 'test_helper'

# Geocoder stubs are defined in test_helper to avoid network calls
# Tests :index and :show actions for successful and error cases
class ForecastControllerTest < ActionDispatch::IntegrationTest
  test 'index success' do
    get root_path
    assert_response :success
  end

  test 'show success' do
    get "#{forecast_path}?address=foo"
    assert_response :success
  end

  test 'show error missing address' do
    get forecast_path
    assert response.code == '400'
    assert_match 'Encountered error during processing', response.body
    assert_match 'Address parameter not supplied', response.body
  end

  test 'show internal error' do
    Forecast.any_instance.expects(:forecast).raises(StandardError.new('some error'))
    get "#{forecast_path}?address=foo"
    assert response.code == '500'
    assert_match 'Encountered error during processing', response.body
    assert_match 'some error', response.body
  end
end
