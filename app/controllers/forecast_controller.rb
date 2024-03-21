# ForecastController is the only controller in the application
# Defines :index action to enter any address
# Defines :show action to display current and daily forecasts

class ForecastController < ActionController::Base
  def index; end

  def show
    raise 'Address parameter not supplied' unless params[:address]

    @forecast = Forecast.new(params[:address]).forecast
  rescue StandardError => e
    @error = e.to_s
    status = params[:address].nil? ? 400 : 500
    render :show, status: status
  end
end
