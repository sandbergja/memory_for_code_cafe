MARC_NS = 'http://www.loc.gov/MARC21/slim'

require 'memory_profiler'
require 'ox'
require 'rubygems/package'
require 'securerandom'
require 'stringio'
require 'zlib'

def process
  MemoryProfiler.start
  filenames = []
  clean_directory
  gzips = (1..5).map do |index|
    xml = Ox.parse(File.read('little_file.xml'))
    write_file gzip(enhance(xml)), index
  end
  MemoryProfiler.stop.pretty_print
  print_report(gzips.count)
end

def enhance(xml)
  subfield = title_subfield(xml).first
  subfield.replace_text "#{SecureRandom.hex} #{subfield.text}"
  Ox.dump xml
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
  xml.root.locate('*/datafield[@tag=245]/subfield[@code=a]')
end

process