

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

    searched_stock = StockActivity::Stock.find_by_name("Apple ")
    attributes_hash = StockActivity::Scraper.scrape_stock_details(searched_stock.url)
    searched_stock.add_more_attributes(attributes_hash)
    

binding.pry

    ### end first time

    puts "Would you like to get more details on a specific stock, please enter the company symbol. View another category? Or exit?"
    #second_input = gets.strip.downcase

    ### IMPLEMENT: SPECIFIC Stock
    # 1. find that stock from StockActivity::Stock.all
    # 2. get its url and pass it into StockActivity::Scraper.scrape_stock_details(url)
    # 3. pass the return value of above into specific_stock.add_more_attributes(attribute_hash)
    # 4. display the stock
    #


    #




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
      puts "Company: " + stock.company_name.colorize(:blue)
      puts "Last Sale: " + stock.last_sale.colorize(:magenta)
      puts "Change Net/%: " + stock.change_net_percentage.colorize(:magenta)
      puts "Share Volume: " + stock.share_volume.colorize(:magenta)
      puts "Volume % Change: " + stock.volume_percentage_change.colorize(:magenta) if stock.volume_percentage_change != nil
      puts "\n"
    end
    nil
  end


end
