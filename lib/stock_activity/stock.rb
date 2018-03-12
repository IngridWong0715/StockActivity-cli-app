class StockActivity::Stock
  attr_accessor :all_details, :company_name, :last_sale, :change_net_percentage, :share_volume, :volume_percentage_change, :url,
  :best_bid_ask, :year_target, :todays_high_low, :share_volume, :day_avg_daily_volume, :previous_close,
  :week_high_low, :market_cap, :pe_ratio, :forward_pe_1y, :earnings_per_share_eps, :annualized_dividend, :ex_dividend_date,
  :dividend_payment_date, :current_yield, :beta, :special_dividend, :special_dividend_date, :special_dividend_payment_date,
  :formatted_detail_pairs, :categories

  @@all = []


  def initialize
    @all_details = []
    @categories = []
  end

  def self.create_from_collection(stocks_array, category)
    stocks_array.each do |stock_hash|
      stock = self.new

      stock_hash.each do |key, value|
        stock.send("#{key}=", value)
      end

      stock.categories << category

      @@all << stock

    end
  end

  def self.find_or_create_from_collection_test(stocks_array, category)
    stocks_array.each do |stock_hash|
      stock = self.new

      stock_hash.each do |key, value|
        stock.send("#{key}=", value)
      end

      stock.categories << category

      @@all << stock

    end
  end



  def add_more_attributes(attribute_hash)
    attribute_hash.each do |key, value|
      self.send("#{key}=", value)
      @all_details << key
    end
  end

  def self.find_by_name(name)
    @@all.detect {|stock| stock.company_name.include?(name)}
  end

  def self.find_by_category(category)
    @@all.select {|stock| stock.categories.include?(category)}
  end

  def self.all
    @@all
  end

end
