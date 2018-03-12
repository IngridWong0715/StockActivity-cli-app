class StockActivity::Stock
  attr_accessor :all_details, :company_name, :last_sale, :change_net_percentage, :share_volume, :volume_percentage_change, :url,
  :best_bid_ask, :year_target, :todays_high_low, :share_volume, :day_avg_daily_volume, :previous_close,
  :week_high_low, :market_cap, :pe_ratio, :forward_pe_1y, :earnings_per_share_eps, :annualized_dividend, :ex_dividend_date,
  :dividend_payment_date, :current_yield, :beta, :special_dividend, :special_dividend_date, :special_dividend_payment_date,
  :formatted_detail_pairs

  @@all = []
  @@most_active = []
  @@most_advanced = []
  @@most_declined = []
  @@dollar_volume = []
  @@unusual_volume = []


  def initialize(stock_hash, category)
    @all_details = []

    stock_hash.each do |key, value|
      self.send("#{key}=", value)
    end

    if category == "most active"
    hello =  @@most_active << self if !@@most_active.include?(self)
    binding.pry
  


    elsif category == "most advanced"
      @@most_advanced << self
    elsif category == "most declined"
      @@most_declined << self
    elsif category == "dollar volume"
      @@dollar_volume << self
    elsif category == "unusual volume"
      @@unusual_volume << self
    end
  end

  def self.create_from_collection(stocks_array, category)
    stocks_array.each {|stock_hash| self.new(stock_hash, category)}

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

  def self.all
    @@all
  end

  def self.find_by_category(category)
    if category == "most active"
      @@most_active
    elsif category == "most advanced"
      @@most_advanced
    elsif category == "most declined"
      @@most_declined
    elsif category == "dollar volume"
      @@dollar_volume
    elsif category == "unusual volume"
      @@unusual_volume
    end
  end




end
