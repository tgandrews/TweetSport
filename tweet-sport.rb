require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'incident'

# Get page from BBC site
doc = open('http://news.bbc.co.uk/sport1/hi/football/live_videprinter/default.stm') { |f| Hpricot(f) }

# Get all the instances
incidents = doc.search("//div[@id='footballVideprinter']/ul/li")

incidents.each do |i|
  inc = MatchIncident.new(i)
  puts 'Type: ' + inc.type.to_s
  puts 'Minutes: ' + inc.minutes.to_s
  puts i
end

