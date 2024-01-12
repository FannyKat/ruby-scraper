require 'selenium-webdriver'
require 'nokogiri'

url = 'https://www.leboncoin.fr/boutique/3551909/yt_motors.htm'

driver = Selenium::WebDriver.for :chrome
driver.get(url)

wait = Selenium::WebDriver::Wait.new(timeout: 10)
wait.until { driver.execute_script('return document.readyState') == 'complete' }

html = driver.page_source

doc = Nokogiri::HTML(html)

thumb_urls = html.scan(/"thumb_url":"([^"]+)"/).map { |match| match[0] }

driver.quit

# Get div cars ads of html document
ads_container = doc.css('.styles_AdsList__voa6p')

if ads_container.any?
  annonces = ads_container.css('a[data-test-id="ad"]')

  annonces.each_with_index do |annonce, index|
    relative_url = annonce['href']
    url = "http://leboncoin.fr#{relative_url}"
    titre = annonce.css('p[data-qa-id="aditem_title"]').text
    prix = annonce.css('span[data-qa-id="aditem_price"]').text
    thumb_url = thumb_urls[index]

    puts "Url: #{url}, Titre: #{titre}, Prix: #{prix}, Image URL: #{thumb_url}"
    puts "-------------------------"
  end
else
  puts "Balise d'annonces introuvable."
end
