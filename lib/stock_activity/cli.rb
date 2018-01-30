#require 'colorize'

class StockActivity::CLI
  def call
    puts "Welcome to Stock Activities! Which kind of stock activity would you like to see?"
    start
  end

  def start
    puts "Please enter: most active, most advanced, most declined, dollar volume, or unusual volume"
    input = gets.strip.downcase
    selector = transform_input_to_selector(input)
    if selector == "Mostactive" || selector == "Advancers" || selector == "Decliners" || selector == "DollarVolume"
      stocks_collection = StockActivity::Scraper.scrape_except_unusual_volume(selector)
      StockActivity::Stock.create_from_collection(stocks_collection)
    elsif selector == "UnusualVolume"
      StockActivity::Stock.create_from_collection(StockActivity::Scraper.scrape_unusual_volume)
    end
    display_stocks
  end

  def transform_input_to_selector(input)
    if input == "most active"
      "Mostactive"
    elsif input == "most advanced"
      "Advancers"
    elsif input == "most declined"
      "Decliners"
    elsif input == "dollar volume"
      "DollarVolume"
    elsif input == "unusual volume"
      "UnusualVolume"
    else
      "Please enter a valid option"
    end
  end

  def display_stocks
    StockActivity::Stock.all.each do |stock|
      puts stock.company_name.colorize(:blue)
      puts stock.last_sale.colorize(:magenta)
      puts stock.change_net_percentage.colorize(:magenta)
      puts stock.share_volume.colorize(:magenta)
      puts stock.volume_percentage_change.colorize(:magenta) if stock.volume_percentage_change != nil
      puts "\n"
    end
    nil
  end


end

#
# show options:
# 	- Most Active
# 	- Most Advanced
# 	- Most Declined
# 	- Dollar Volume
# 	- Unusual Volume
# User picks one option
# Display each company, last sasle, change net/%, share volume
