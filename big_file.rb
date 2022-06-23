MARC_NS = 'http://www.loc.gov/MARC21/slim'
XML_PATH =  'big_file.xml'

require 'nokogiri'
require 'byebug'
modified_xml = (1..100).map do |i|
  xml = Nokogiri::XML(File.read(XML_PATH))
  subfield = xml.xpath('//marc:datafield[@tag="245"]/marc:subfield[@code="a"]', 'marc' => MARC_NS).first
  subfield.content = "#{i} subfield.content"
  File.write(XML_PATH, xml)
  xml
end
