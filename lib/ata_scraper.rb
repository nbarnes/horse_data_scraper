# This scraper is designed to pull data from the American Trakehner
# Association's site, located at americantrakehner.com

require 'capybara-webkit'
require_relative './horse.rb'
require 'json'
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


    def json_for_initial(initial, limiter=0)
      visit URL_for_initial(initial)
      rows = results_as_rows(page, initial)

      f = File.open("output/horses_initial_#{ initial }.json", 'wb')
      puts "#{ rows.count } total rows to process"

      puts "Limiter is set to #{ limiter }"

      f.write JSON.generate(rows_as_horses(rows, limiter))
    end

    def URL_for_initial(initial)
      "http://americantrakehner.com/results/hsearch.asp?searchname=#{ initial }"
    end

    def results_as_rows(page, initial)
      rows = page.all(:xpath, '/html/body/table[2]/tbody/tr')
      puts "Got page from americantrakehner.com for inital #{ initial }, counted #{ rows.count } records"
      # The first two lines of the table are table headers, strip them out
      rows = rows.drop(2)
      # The last line is a table footer, strip it, too
      rows.take( rows.count - 1 )
    end

    def rows_as_horses(rows, limit)
      horses = Array.new
      puts "Start of rows_as_horses, #{ rows.size } rows to parse"
      rows.each_with_index do |row, index|

        horses << row_as_horse(row)]

        if limit != 0
          index >= limit ? break : nil
        end

      end
      return horses
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
