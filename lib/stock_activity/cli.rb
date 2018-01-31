

class StockActivity::CLI

  attr_accessor :second_input
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

    ### end first time

    puts "Would you like to get more details on a specific stock, please enter the company symbol. View another category? Or exit?"
    @second_input = gets.strip

    ### IMPLEMENT: SPECIFIC Stock
    # 1. find that stock from StockActivity::Stock.all
    # 2. get its url and pass it into StockActivity::Scraper.scrape_stock_details(url)
    # 3. pass the return value of above into specific_stock.add_more_attributes(attribute_hash)
    # 4. display the stock
    #

    searched_stock = StockActivity::Stock.find_by_name(second_input)
    attributes_hash = StockActivity::Scraper.scrape_stock_details(searched_stock.url)
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

  def display_stock_details(stock)

    puts "\n#{stock.company_name} Common Stock Quote & Summary Data".colorize(:blue)
    puts "#{stock.last_sale.colorize(:magenta)} #{stock.change_net_percentage.colorize(:magenta)}"
    puts "\n\n"
    puts "Key Stock Data \n"

    stock.all_details.each do |detail|
      puts "#{detail}: #{stock.send(detail)} "
    end
    # puts "Best Bid / Ask: " + stock.best_bid_ask.colorize(:magenta)
    # puts "1 Year Target: " + stock.year_target.colorize(:magenta)
    # puts "Today's High / Low: " + stock.todays_high_low.colorize(:magenta)
    # puts "Share Volume: " + stock.share_volume.colorize(:magenta)
    # puts "50 Day Avg. Daily Volume: " + stock.day_avg_daily_volume.colorize(:magenta)
    # puts "Previous Close: " + stock.previous_close.colorize(:magenta)
    # puts "52 Week High / Low: " + stock.week_high_low.colorize(:magenta)
    # puts "Market Cap: " + stock.market_cap.colorize(:magenta)
    # puts "P/E Ratio: " + stock.pe_ratio.colorize(:magenta)
    # puts "Forward P/E (1y): " + stock.forward_pe_1y.colorize(:blue)
    # puts "Earnings Per Share (EPS): " + stock.earnings_per_share_eps.colorize(:magenta)
    # puts "Annualized Dividend: " + stock.annualized_dividend.colorize(:magenta)
    # puts "Ex Dividend Date: " + stock.ex_dividend_date.colorize(:magenta)
    # puts "Dividend Payment Date: " + stock.dividend_payment_date.colorize(:magenta)
    # puts "Current Yield: " + stock.current_yield.colorize(:magenta)
    # puts "Beta: " + stock.beta.colorize(:magenta)
      nil
  end



end
