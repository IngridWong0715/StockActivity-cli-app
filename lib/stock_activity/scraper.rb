require_relative '../stock_activity.rb'
class StockActivity::Scraper

  # def self.get_page
  #   Nokogiri::HTML(open("http://www.nasdaq.com/"))
  # end

  def self.scrape_most_active
    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))


    # companies = doc.search("div#Mostactive div.coName a").children #all companies: company name then company_symbol
    # names = companies.collect do |company|
    #   company.text
    # end


    companies = doc.search("div#Mostactive tbody tr")

    all = doc.css("div#Mostactive tr > td").children
    acc = all.reduce([]) do |accumulator, company|
      if company.text != "\r\n                                " && company.text != "\r\n                            " && company.text != ""
        accumulator << company.text
      end
      accumulator
    end
    acc.map! do |info|
      info.include?("\r\n") ? info.scan(/[A-Z].*\)/).first : info
    end

    #turn acc into nested array:
    counter = 0
    subarray = []

    nested = acc.reduce([]) do |accumulator, info|
      if counter < 3
        subarray << info
        counter += 1
      #  binding.pry
    elsif counter == 3
        subarray << info
        accumulator << subarray
        subarray = []
        counter = 0

      end
    #  binding.pry

      accumulator
    end

binding.pry




    # companies_info = []
    # acc.each_with_index do |info, index|
    #   company = {}
    #   if index % 4 == 0
    #     company[:company_name] = info
    #
    #   elsif index % 4 == 1
    #
    #     company[:last_sale] = info
    #   elsif index % 4 == 2
    #     company[:change_net_percentage] = info
    #   elsif index % 4 == 3
    #     company[:share_volume] = info
    #     companies_info << company
    #   end
    #
    # end
    # binding.pry
    # companies_info


    #return : ["Apple Inc. (AAPL)", "$168.7602", "2.75 ▼ 1.60%", "30,994,884", "Intel Corporation (INTC)", "$50.37", "0.29 ▲ 0.58%", "24,601,812", "PowerShares QQQ Trust, Series 1 (QQQ)", "$170.705", "0.23 ▼ 0.13%", "21,308,460", "Micron Technology, Inc. (MU)", "$42.97", "0.70 ▼ 1.60%", "18,873,253", "Wynn Resorts, Limited (WYNN)", "$164.65", "15.64 ▼ 8.67%", "18,731,482"]


    #returns an array of hashes
    #each hash represent a company {:company => , :last_sale, :change_net_percentage, :share_volume}
  end

  def self.scrape_most_advanced
  end

  def self.scrape_most_declined
  end

  def self.scrape_dollar_volume
  end

  def self.scrape_unusual_volume
  end

end
