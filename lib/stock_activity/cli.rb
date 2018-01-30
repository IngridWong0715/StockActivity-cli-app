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

      acc = StockActivity::Stock.all

    elsif selector == "UnusualVolume"
      StockActivity::Stock.create_from_collection(StockActivity::Scraper.scrape_unusual_volume)
      acc = StockActivity::Stock.all
    end

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
    elsif input == "exit"
      "Exit"
    else
      "Please enter a valid option"
    end
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
