require 'test_helper'
require "scraper"

describe "scraper" do

  it "Will peel results from Google" do
    s = Scraper.new
    s.get_results
  end

end