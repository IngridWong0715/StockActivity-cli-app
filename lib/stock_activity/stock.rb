class StockActivity::Stock
  attr_accessor :company_name, :company_symbol, :last_sale, :change_net_percentage, :share_volume, :volume_percentage_change

  @@all = []
  def self.create_from_collection(stocks_array)
    stocks_array.each {|stock| StockActivity::Stock.new(stock)}
  end

  def initialize(stock_hash)
    stock_hash.each {|key, value| self.send("#{key}=",value) }
    @@all << self

    #{:company_name=>"Apple Inc. (AAPL)", :last_sale=>"$167.96", :change_net_percentage=>"3.55 ▼ 2.07%", :share_volume=>"47,289,579"},
  end

  def self.all
    @all
  end
end
