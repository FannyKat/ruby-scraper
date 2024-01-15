require 'selenium-webdriver'
require 'nokogiri'

url = 'https://www.leboncoin.fr/boutique/3551909/yt_motors.htm'

driver = Selenium::WebDriver.for :chrome
driver.get(url)

wait = Selenium::WebDriver::Wait.new(timeout: 10)
wait.until { driver.execute_script('return document.readyState') == 'complete' }

html = driver.page_source

doc = Nokogiri::HTML(html)

# Retrieve images url based on size

image_urls = html.scan(/"urls":\s*\[([^\]]*rule=ad-image[^\]]*)\]/).flatten
#thumb_urls = html.scan(/"thumb_url":"([^"]+)"/)

driver.quit

# Get div cars ads of html document
ads_container = doc.css('.styles_AdsList__voa6p')

if ads_container.any?
  annonces = ads_container.css('a[data-test-id="ad"]')

  ad_data = []

  annonces.each_with_index do |annonce, index|
    relative_url = annonce['href']
    url = "http://leboncoin.fr#{relative_url}"
    titre = annonce.css('p[data-qa-id="aditem_title"]').text
    prix = annonce.css('span[data-qa-id="aditem_price"]').text
    #thumb_url = thumb_urls[index]
    first_img_url = image_urls[index].split(",")[0].gsub('"', '')

    ad_hash = {
      "url" => url,
      "titre" => titre,
      "prix" => prix,
      "img_url" => first_img_url
    }

    ad_data << ad_hash

    puts "Url: #{url}, Titre: #{titre}, Prix: #{prix}, Image URL: #{first_img_url}"
    puts "-------------------------"
  end

# Save data to a JSON file
  File.open('annonces.json', 'w') do |file|
    file.write(JSON.pretty_generate(ad_data))
  end

  puts "Data saved to annonces.json"
else
  puts "Balise d'annonces introuvable."
end
