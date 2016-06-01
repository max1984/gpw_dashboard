require 'nokogiri'
require 'net/http'
require 'json'

# uri = URI('http://www.money.pl/gielda/gpw/akcje/')

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
    if !post.at_css('.link').nil?
      if  !post.at_css('.r_bz').nil?
        kurs = post.at_css('b').content.to_s
	procent = post.at_css('.r_bz').content.to_s
	status = 4
      elsif !post.at_css('.r_dn').nil?
	kurs = post.at_css('b').content.to_s
        procent = post.at_css('.r_dn').content.to_s
	status = 0
      elsif !post.at_css('.r_up').nil?
	kurs = post.at_css('b').content.to_s
        procent = post.at_css('.r_up').content.to_s
	status = 1 
      else
        next # skip empty items
      end
      nazwa = post.at_css('.link').content.to_s
      akcja.each do |papier|
        if papier[:nazwa] == nazwa
          str = procent +" %       " + kurs + " pln" 
          data = {:result => status, :info => str, :title => papier[:nazwa]}
          send_event(papier[:akcja_id], data)
        end
      end # end of loop for checking each akcja
    end
  end
end
