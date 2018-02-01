

class StockActivity::CLI

  #attr_accessor :second_input
  def start
    puts "\n\nWelcome to Stock Activities! This program lets you view daily stock activities.\n\n"
    main_loop
  end

  def main_loop
    input = nil
    while input != "exit"
      puts "Would you like to view a category, get more details on a specific stock from the above category, or exit?"
      puts "I accept: category, stock, and exit\n"
      input = gets.strip.downcase
      if input == "stock"
        detail_view
      elsif input == "category"
        view_category
      elsif input == "exit"
        puts "Goodbye."
        exit
      else
        puts "Invalid input. Please enter: stock, category, or exit\n"
      end
    end
  end

  def view_category
    puts "Which type of stock activity would you like to see?"
    puts "I accept: most active, most advanced, most declined, dollar volume, unusual volume\n"

    input = gets.strip.downcase
    selector = transform_input_to_selector(input)
    stocks_collection = StockActivity::Scraper.scrape(selector)
    StockActivity::Stock.create_from_collection(stocks_collection)
    display_stocks



  end

  def detail_view
    puts "Please enter the stock symbol.\n"
    input = gets.strip

    searched_stock = StockActivity::Stock.find_by_name(input)
    attributes_hash = StockActivity::Scraper.scrape_stock_details(searched_stock)
    searched_stock.add_more_attributes(attributes_hash)
    display_stock_details(searched_stock)

    main_loop

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
    
      puts "#{detail[0]}: #{detail[1]} "
    end
    puts "\n\n"
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
