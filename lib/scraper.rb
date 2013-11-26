
require "capybara-webkit"
require "CSV"

class Scraper

  include Capybara::DSL

  Capybara.current_driver = :webkit

    def get_results
      visit('http://www.google.com/')
      fill_in "q", :with => "Capybara"
      click_button "Google Search"

      csv = CSV.open("google_links.csv", "wb")

      all(:xpath, "//li[@class='g']/h3/a").each do |link|
        s = link[:href]
        puts s
        csv.add_row [s]
      end

      csv.close

    end

end
