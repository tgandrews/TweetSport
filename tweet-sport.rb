require 'rubygems'
require 'hpricot'
require 'open-uri'

require 'instance'

# Get page from BBC site
doc = open('http://news.bbc.co.uk/sport1/hi/football/live_videprinter/default.stm') { |f| Hpricot(f) }

# Get all the instances
instances = doc.search("//div[@id='footballVideprinter']/ul/li")

instances.each do |i|
  #if instance.
  inst = MatchInstance.new(i)
  puts 'Type: ' + inst.type.to_s
  puts 'Minutes: ' + inst.minutes.to_s
  puts i
end

