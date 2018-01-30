class StockActivity::Stock
  attr_accessor :company_name, :last_sale, :change_net_percentage, :share_volume, :volume_percentage_change, :url

  @@all = []

  def initialize(stock_hash)
    stock_hash.each {|key, value| self.send("#{key}=", value)}
    @@all << self
  end

  def self.create_from_collection(stocks_array)
    stocks_array.each {|stock_hash| self.new(stock_hash)}
  end

  def self.all
    @@all
  end
end
