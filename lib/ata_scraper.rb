# This scraper is designed to pull data from the American Trakehner
# Association's site, located at americantrakehner.com

require 'capybara-webkit'
require_relative './horse.rb'
require 'pry'

DATA_COLUMNS_IN_HORSE_ROW = [
  'name',
  'registration_num',
  'sex',
  'color',
  'birth_year',
  'sire',
  'dam',
  'dam_sire',
  'breeder',
  'performance_records_available'
]

class ATAScraper

  include Capybara::DSL
  Capybara.current_driver = :webkit

    def json_for_initial(initial)
      visit URL_for_initial(initial)
      rows = results_as_rows(page, initial)

      f = File.open("horses_initial_#{ initial }.json", 'wb')
      row_count = 0
      puts "#{ rows.count } total rows to process"
      rows.each do |row|
        f.write row_as_horse(row).to_json

        row_count += 1
        if row_count % 500 == 0
          puts("#{ row_count } rows parsed")
        end

      end
    end

    def URL_for_initial(initial)
      "http://americantrakehner.com/results/hsearch.asp?searchname=#{ initial }"
    end

    def results_as_rows(page, initial)
      rows = page.all(:xpath, '/html/body/table[2]/tbody/tr')
      puts "Got page from americantrakehner.com for inital #{ initial }, counted #{ rows.count } records"
      # The first two lines of the table are headers, strip them out
      rows.drop(2)
    end

    def row_as_horse(row)
      columns = row.all(:xpath, 'td')
      associations = Hash[DATA_COLUMNS_IN_HORSE_ROW.zip columns]
      horse = Horse.new
      associations.each do |property_name, column|
        horse.send("#{ property_name }=", column.text)
      end
      horse
    end

end
