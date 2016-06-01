require 'nokogiri'
require 'net/http'
require 'json'

# uri = URI('http://www.money.pl/gielda/gpw/akcje/')

# bots = [
#         {bot_name: 'iPad 2', bot_id: '9f8c344804e3aa04a080d51eb1d94fe5', target: 'robo1'},
#         {bot_name: 'iPhone 6s', bot_id: '9f8c344804e3aa04a080d51eb1d953f6', target: 'robo2'},
#         {bot_name: 'iPhone 6+', bot_id: '9f8c344804e3aa04a080d51eb1d95b60', target: 'robo3'},
#         {bot_name: 'Unit tests', bot_id: '9f8c344804e3aa04a080d51eb1d96e40', target: 'robo5'},
#         {bot_name: 'iPad Air 2', bot_id: '9f8c344804e3aa04a080d51eb1f97656', target: 'robo4'}
#        ]

money = URI.parse("http://www.money.pl/")
last = 0
akcja = [
  {nazwa: 'URSUS', akcja_id: 'URS' },
  {nazwa: 'PKN ORLEN', akcja_id:'PKN'}
]

def get_content_of_page(money)
  http = Net::HTTP.new(money.host, money.port)
  req = Net::HTTP::Get.new("/gielda/gpw/akcje/")
  response = http.request(req)
  return response.body
end

SCHEDULER.every '1m', :first_in => 0 do
  strona = get_content_of_page(money)
  page = Nokogiri::HTML(strona)
  page.search('//@ac').remove
  temp = page.css('.tr1','.tr2')
  temp.each do |post|
    status = 4
    if !post.at_css('.link').nil?
      if  !post.at_css('.r_bz').nil?
        kurs = post.at_css('.r_bz').content.to_s
      elsif !post.at_css('.r_dn').nil?
        kurs = post.at_css('.r_dn').content.to_s
      elsif !post.at_css('.r_up').nil?
        kurs = post.at_css('.r_up').content.to_s
      else
        next # skip empty items
      end
      puts post[:nazwa]
      nazwa = post.at_css('.link').content.to_s
      akcja.each do |papier|
        if papier[:nazwa] == nazwa
          puts nazwa + " " + kurs # only for debuging
          str = kurs
          status = 1 # bo be detailed
          data = {:result => status, :info => str, :title => post[:nazwa]}
          puts data
          puts post[:akcja_id]
          send_event(post[:akcja_id], data)
        end
      end # end of loop for checking each akcja
    end
  end
end
