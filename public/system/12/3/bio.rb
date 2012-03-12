require 'optparse'
require 'pp'

filename = "/home/clem/test.csv"
outfile = "/home/clem/agenceBio.csv"
def replace_wrong_space_char a
  b = [194, 160]
  c = [32]

  out= []
  changing = 0

  a.each_byte do |i|
    changing = 1 if i == b[0]
    changing = 2 if i == b[1] and changing == 1
    out << i if changing == 0
    if changing == 2
      out += c
      changing = 0
    end
  end
  return out.pack('c*').force_encoding('UTF-8')
end

output = []
stats = {}
count = File.foreach(filename).inject(0) {|c, line| c+1}

File.open(filename, 'r') do |f|
  while line = f.gets
    output << replace_wrong_space_char(line)
  end
end
#puts output.join

File.open(outfile, 'a') {|f| f.write(output.sort.uniq.join) }

