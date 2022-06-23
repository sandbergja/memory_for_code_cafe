require 'nokogiri'
File.open("big_file.xml") do |file|
  10.times do
    Nokogiri::XML(file)
  end
end