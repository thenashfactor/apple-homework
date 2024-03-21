# ForecastController is the only controller in the application
# Defines :index action to enter any address
# Defines :show action to display current and daily forecasts
# :show displays an error message if an exception bubbles up

class ForecastController < ActionController::Base
  def index; end

  def show
    begin
      raise ArgumentError.new('Address parameter not supplied') unless params[:address].present?
      @forecast = Forecast.new(params[:address]).forecast
    rescue => e
      status = e.instance_of?(ArgumentError) ? 400 : 500
      @error = e.message
      render :show, status: status
    end
  end
end
