class StockActivity::CLI

  def start
    puts "\n\nWelcome to Stock Activities! This program lets you view daily stock activities.\n\n"
    main_loop
  end

  def main_loop
    view_category
    input = nil
    while input != "exit"
      puts "Would you like to view another category, get more details on a specific stock from the above category, or exit?"
      puts "I accept: category, stock, and exit\n"
      input = gets.strip.downcase
      if input == "stock"
          detail_view
      elsif input == "category"
        view_category
      elsif input == "exit"
        puts "Goodbye."
        exit
      elses
        puts "Invalid input. Please enter: stock, category, or exit\n"
      end
    end
  end

  def view_category
    puts "Which type of stock activity would you like to see?"
    puts "I accept: most active, most advanced, most declined, dollar volume, unusual volume\n"
    input = gets.strip.downcase
    while !(["most active", "most advanced", "most declined", "dollar volume", "unusual volume"].include?(input))
      puts "Invalid input. Please enter  most active, most advanced, most declined, dollar volume, unusual volume\n"
      input = gets.strip.downcase
    end
    selector = transform_input_to_selector(input)
    stocks_collection = StockActivity::Scraper.scrape(selector)
    StockActivity::Stock.create_from_collection(stocks_collection)
    display_stocks
  end

  def detail_view
    puts "Please enter the stock symbol.\n"
    input = gets.strip.upcase
    while StockActivity::Stock.find_by_name(input) == nil
      puts "Invalid input. Please enter a stock symbol that's been displayed."
      input = gets.strip.upcase
    end
    searched_stock = StockActivity::Stock.find_by_name(input)
    attributes_hash = StockActivity::Scraper.scrape_stock_details(searched_stock)
    searched_stock.add_more_attributes(attributes_hash)
    display_stock_details(searched_stock)
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
    puts "\n\n"
    StockActivity::Stock.all.each do |stock|
      puts "Company: " + stock.company_name.colorize(:blue)
      puts "Last Sale: " + stock.last_sale.colorize(:magenta)
      puts "Change Net/%: " + stock.change_net_percentage.colorize(:magenta)
      puts "Share Volume: " + stock.share_volume.colorize(:magenta)
      puts "Volume % Change: " + stock.volume_percentage_change.colorize(:magenta) if stock.volume_percentage_change != nil
      puts "\n\n"
    end
    nil
  end

  def display_stock_details(stock)
    puts "\n\n"
    puts "\n#{stock.company_name} Common Stock Quote & Summary Data".colorize(:blue)
    puts "#{stock.last_sale.colorize(:magenta)} #{stock.change_net_percentage.colorize(:magenta)}"
    puts "\n"
    puts "Key Stock Data \n"
    stock.formatted_detail_pairs.each do |detail|
      puts "#{detail[0]}: #{detail[1].colorize(:magenta)} "
    end
    puts "\n\n"
    nil
  end

end
