class Client::GeocoderClient
  # Geocode a supplied address
  #
  # Raises error message if geocoding fails
  #
  # country_code defaults to 'US' unless the country code is supplied after
  # the last comma in the supplied address
  def geocode(raw_address)
    raw_country_code = raw_address.split(',').last.strip
    raw_country_code = Country.find_country_by_alpha2(raw_country_code)&.alpha2 ||
                       Country.find_country_by_alpha3(raw_country_code)&.alpha3
    geocoder_result = Geocoder.search(
      raw_address,
      params: { countrycodes: raw_country_code || 'US' }
    )&.first
    if geocoder_result.nil?
      error = "Geocoder: No result for address #{raw_address}"
    elsif geocoder_result.data['error']
      error = "Geocoder: #{geocoder_result.data['error']} address #{raw_address}"
    end
    raise error if error

    geocoder_result
  end
end
