MARC_NS = 'http://www.loc.gov/MARC21/slim'

require 'nokogiri'
require 'rubygems/package'
require 'securerandom'
require 'stringio'
require 'zlib'

# Very contrived example:
# It reads a file 20 times,
# each time adding an "enhancement"
# of dubious quality.
# It then compresses the files
# and leaves them in this directory
def process
  filenames = []
  clean_directory
  gzips = (1..20).map do |index|
    xml = Nokogiri::XML(File.read("big_file_#{index}.xml"))
    gzip enhance(xml)
  end
  write_files gzips
end

def enhance(xml)
  subfield = title_subfield(xml).first
  subfield.content = "#{SecureRandom.hex} #{subfield.content}"
  xml.to_s
end

def write_files(contents)
  contents.each_with_index { |io, index| write_file(io, index) }
  print_report(contents.count)
end

def write_file(io, index)
  output_filename = "temp_#{index}.gz"
  File.open(output_filename, 'w') do |file|
    file.puts io.string
  end
end

def print_report(count)
  puts "#{count} files processed"
end

def gzip(contents)
  io = StringIO.new
  gz = Zlib::GzipWriter.new io
  gz.write contents
  gz.close
  io
end

def clean_directory
  `rm temp*`
end

def title_subfield(xml)
  xml.xpath('//marc:datafield[@tag="245"]/marc:subfield[@code="a"]', 'marc' => MARC_NS)
end

process
