require 'net/http'
require 'sinatra'
require 'tilt/erubis'
require 'rufus-scheduler'
require 'xmlsimple'

# configuration
woe_id = ENV['WOE_ID'] || 2475687

snowing = false
snowing_conditions = [
  5,  #snow
  6,  #sleet
  7,  #snow
  10, #sleet
  13, #snow
  14, #snow
  15, #snow
  16, #snow
  18, #snow
  41, #snow
  42, #snow
  43, #snow
  46 #snow
]

scheduler = Rufus::Scheduler.new
scheduler.every '3m', :first_in => '1s' do |job|
  http = Net::HTTP.new('weather.yahooapis.com')
  response = http.request(Net::HTTP::Get.new("/forecastrss?w=#{woe_id}"))
  weather_data = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['item']['condition']
  snowing = true #snowing_conditions.include?(weather_data['code'].to_i)
end

get '/' do
  if snowing
    erb :yes
  else
    erb :no
  end
end
