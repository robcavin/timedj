# runs through the maxmind locations file and removes the countries then builds a mysql .dat file

require 'rubygems'
require 'fastercsv'

# load the population list
csv_in = FasterCSV.open(ARGV[0], "r")
country_pops = {}
csv_in.each do |line|
  country_pops[line[0].downcase] = line[1].strip.gsub(' ','').to_i
end

# load the countries list
csv_in = FasterCSV.open(ARGV[1], "r")

line_num = 1
csv_in.each do |line|
  country_code = line[0]
  next if country_code.size > 2 # skip the title
  country_name = line[1].gsub(',','-') # get rid of commas
  country_pop = country_pops[country_name.downcase]
  if !(country_pop)
    country_pop = "\\N"
  end
  puts "#{line_num},\"#{country_name}\",\"#{country_code}\",#{country_pop}"
  line_num += 1
end

