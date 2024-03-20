# Geocoding service defaults to nominatim index
Geocoder.configure(
  # Geocoding service request timeout, in seconds (default 3):
  timeout: 10,

  # set default units to miles
  units: :mi
)
