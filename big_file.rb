MARC_NS = 'http://www.loc.gov/MARC21/slim'
XML_PATH =  'big_file.xml'

require 'nokogiri'
require 'rubygems/package'
require 'securerandom'
require 'stringio'

def process
  filenames = []
  gzips = (1..50).map do |index|
    xml = Nokogiri::XML(File.read(XML_PATH))
    gzip enhance(xml)
  end
  write_files(gzips)
  cleanup
end

def enhance(xml)
  subfield = title_subfield(xml).first
  subfield.content = "#{SecureRandom.hex} #{subfield.content}"
  byebug
  xml.to_s
end

def write_files(contents)
  contents.each_with_index do |io, index|
    output_filename = "temp_#{index}.gz"
    File.open(output_filename, 'w') do |file|
      file.puts io.string
    end
  end
  puts "#{contents.count} files processed"
end

def gzip(contents)
  io = StringIO.new
  gz = Zlib::GzipWriter.new io
  gz.write contents
  gz.close
  io
end

def cleanup
  `rm temp*`
end

def title_subfield(xml)
  xml.xpath('//marc:datafield[@tag="245"]/marc:subfield[@code="a"]', 'marc' => MARC_NS)
end

process