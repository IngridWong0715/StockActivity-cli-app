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
