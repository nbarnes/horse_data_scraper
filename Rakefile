require 'rake/testtask'
require_relative './lib/ata_scraper.rb'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/**/*_test.rb"
end

task :scrape_ata do
  s = ATAScraper.new
  s.json_for_initial('a')
end

task default: :scrape_ata