require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

COUNTER = "/home/clem/counter"
OUTPUT_FILE = "/home/clem/test.csv"

def parse_mail(mail)
  out = ""
  mail.split("\n").each do |i|
    if i =~ /\+\="/
      out += i.strip.gsub("monmail +=\"", "").gsub("\";", "")
    end
  end
  return out.gsub("\'>","")
end

def puts_details str
  puts "   * " + str.strip[0..50]
end

def parse_address address
  if address =~ /\w[0-9]{5}/
    postal_code = address[/\w([0-9]{5}.*)/, 1]
    address = address.insert(address.index(postal_code), " ")
  end
  return address
end

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

companies = []
File.open(OUTPUT_FILE, "r") do |f|
  while line = f.gets
    obj = line[/^(.*?);/, 1]
    companies << replace_wrong_space_char(obj)
  end
end
#companies.sort!.uniq!
puts companies.size
page_number = File.open(COUNTER, "r") {|f| f.readline.chomp!}

url = "http://annuaire.agencebio.org/"
search_page = "pageListe.asp,id,183D33A0,categorie,1.rwi.html"
search_page = "pageListe2.asp,id,F5778AA3,page,#{page_number}.rwi.html" #IDES Didier
last_page = "pageListe.asp,id,183D33A0,categorie,1,page,2259.rwi.html"

while search_page
  puts "  #{page_number}  ".center(60, "*")
  puts "  #{search_page}  ".center(60, "*") + "\n\n"

  File.open(COUNTER, 'w') {|f| f.puts(page_number) }

  doc = Nokogiri::HTML(open(url + search_page).read)

  doc.css("a.libelleacteur").each do |item|

    if companies.include? item.text
      puts "Company already present"
      puts "Skipping #{item.text}\n\n"
      next
    else
      companies << replace_wrong_space_char(item.text)
    end
    output = []

    html = open(url + item[:href]).read
    if html =~ /Fiche op&eacute;rateur inaccessible/
      puts "Fiche operateur inaccessible"
      puts "Skipping #{item.text}\n\n"
      next
    else
      puts item.text
    end

    detail = Nokogiri::HTML(html)
    puts_details detail.at_css("b").text # Entreprise

    output << detail.at_css("b").text.strip

    detail.css("div.itemcat").each do |d|
      o = nil
      if d.text =~ /monmail/
        o = parse_mail d.text
      else
        if d.text =~ /[0-9]{5}/
          o = parse_address d.text
        else
          o = d.text.strip
        end
      end
      puts_details o if o
      output << o if o
    end

    puts

    # Append to file
    File.open(OUTPUT_FILE, 'a') {|f| f.write(output.join(";")+"\n") }
  end

  begin
    page_number = doc.at_css("a.lien2gras").next_element.text
    search_page = doc.at_css("a.lien2gras").next_element[:href]
  rescue
    puts "Last page reached (#{search_page})"
    exit
  end
end
