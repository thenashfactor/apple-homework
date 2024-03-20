class ForecastController < ActionController::Base
  def index
  end

  def show
    begin 
      raise "Address parameter not supplied" unless params[:address]
      @forecast = Forecast.new(params[:address]).get_forecast
    rescue => e
      @error = e.to_s 
      params[:address].nil? ? status = 400 : status = 500
      render :show, status: status
    end
  end
end