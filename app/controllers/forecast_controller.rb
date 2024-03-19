class ForecastController < ActionController::Base
  def index
  end

  def show
    raise "Address parameter not supplied" unless params[:address]
    @address = Address.new(params[:address])
    @forecast = Forecast.new(@address).get_forecast
  end
end