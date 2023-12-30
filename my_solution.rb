require "http"
require "json"

#Initial start:
border = "="

puts border*35
puts "Will you need an umbrella today?"
puts border*35
puts "Where are you?"
input_location = gets.strip()
puts input_location
puts "Checking the weather at #{input_location}..."

#Using Google Maps API to find out the longitude and latitude:
gmaps_api_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{input_location}&key=#{gmaps_api_key}"
