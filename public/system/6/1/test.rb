require 'optparse'
require 'pp'

options = {}
scr_size = 80

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: test.rb [options]"

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end

  options[:file] = nil
  opts.on( '-i', '--input-file FILE', 'Use special FILE' ) do |f|
    options[:file] = f
  end

  options[:full] = false
  opts.on( '-f', '--full', 'Display full emails list with names' ) do
    options[:full] = true
  end

  options[:emails] = false
  opts.on( '-e', '--emails', 'Display emails list' ) do
    options[:emails] = true
  end

  options[:lenght] = false
  opts.on( '-l', '--lenght', 'Display number of emails' ) do|file|
    options[:lenght] = true
  end

  options[:stats] = false
  opts.on( '-s', '--stats', 'Display statistics' ) do
    options[:stats] = true
  end
end

optparse.parse!

filename =  (options[:file].nil? ? "/home/clem/test.csv" : options[:file])

emails = []
stats = {}
count = File.foreach(filename).inject(0) {|c, line| c+1}

if not options[:stats]
  File.open(filename, 'r') do |f|
    while line = f.gets
      line.split(";").each do |item|
        if item =~ /@/
          obj = line[/^(.*?);/, 1].capitalize.ljust(50, '.').gsub("  ", " ") if options[:full]
          obj = (obj.nil? ? item.downcase : obj + item.downcase)
          emails << obj
        end
      end
    end
  end
else
  File.open(filename, 'r') do |f|
    while line = f.gets
      if stats.keys.include? line[0,1]
        stats[line[0,1]] += 1
      else
        stats[line[0,1]] = 1
      end
    end
  end
end
puts emails.sort!.uniq!.join("\n") + "\n" if options[:full] or options[:emails]
puts "Nombre d'emails: #{emails.size} / #{count}" if options[:full] or options[:lenght]


if options[:stats]
  max = stats.values.max
  stats.each_pair do |k,v|
    puts k + " : [" + "#" * (v*scr_size/max) + "." * ((max - v)*scr_size/max) + "] #{v}"
  end
end
