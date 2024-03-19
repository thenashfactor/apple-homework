class Address
  include ActiveModel::API

  attr_accessor :house_number, :street, :city, :state, :postal_code, :country_code, :latitude, :longitude
  
  # Geocode a supplied address
  #
  # Raises error message if geocoding fails
  #
  # country_code defaults to 'US' unless the country code is supplied after
  # the last comma in the supplied address
  def initialize(supplied_address)
    supplied_country_code = supplied_address.split(',').last.strip
    supplied_country_code = Country.find_country_by_alpha2(supplied_country_code)&.alpha2
    @geocoded_address = Geocoder.search(
      supplied_address,
      params: {countrycodes: supplied_country_code || "US"}
    )&.first
    error = @geocoded_address.data["error"]
    raise error if error

    @house_number = @geocoded_address.house_number
    @street = @geocoded_address.street
    @city = @geocoded_address.city
    @state = @geocoded_address.state
    @postal_code = @geocoded_address.postal_code
    @country_code = @geocoded_address.country_code.upcase
    @latitude = @geocoded_address.latitude
    @longitude = @geocoded_address.longitude
  end

  def formatted_address
    [house_number, street, city, state, postal_code, country_code].compact.join(', ')
  end
end