class ForecastController < ActionController::Base
  def index; end

  def show
    raise 'Address parameter not supplied' unless params[:address]

    @forecast = Forecast.new(params[:address]).get_forecast
  rescue StandardError => e
    @error = e.to_s
    status = params[:address].nil? ? 400 : 500
    render :show, status:
  end
end
