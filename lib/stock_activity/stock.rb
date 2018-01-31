class StockActivity::Stock
  attr_accessor :company_name, :last_sale, :change_net_percentage, :share_volume, :volume_percentage_change, :url, :"best_bid_/_ask", :"1_year_target",
   :"today's_high_/_low", :share_volume, :"50_day_avg._daily_volume", :previous_close, :"52_week_high_/_low", :market_cap, :"p/e_ratio",
   :"forward_p/e_(1y)", :"earnings_per_share_(eps)", :annualized_dividend, :ex_dividend_date, :dividend_payment_date, :current_yield, :beta


  @@all = []

  def initialize(stock_hash)
    stock_hash.each {|key, value| self.send("#{key}=", value)}
    @@all << self
  end

  def self.create_from_collection(stocks_array)
    stocks_array.each {|stock_hash| self.new(stock_hash)}
  end

  def add_more_attributes(attribute_hash)
    attribute_hash.each {|key, value| self.send("#{key}=", value)}
  end

  def self.all
    @@all
  end
end
