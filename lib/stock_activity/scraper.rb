# REMARQUE:
# refactor most active - dollar Volume
# keep unusual volume: has one additional column: volume_percentage_change

require_relative '../stock_activity.rb'


class StockActivity::Scraper

  def self.scrape_except_unusual_volume(selector)
    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))
    companies =  doc.css("div\##{selector} tr > td").children.reduce([]) do |accumulator, company|
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text.strip
      end
    accumulator
    end

  #turn acc into nested array:
    counter = 0
    subarray = []
    nested = companies.reduce([]) do |accumulator, info|
      if counter < 3
        subarray << info
        counter += 1

    elsif counter == 3
        subarray << info
        accumulator << subarray
        subarray = []
        counter = 0

      end

      accumulator
    end

    companies_info = []
    nested.each do |company_group|
      company = {}
      company_group.each_with_index do |info, index|
        if index % 4 == 0
          company[:company_name] = info
        elsif index % 4 == 1
          company[:last_sale] = info
        elsif index % 4 == 2
          company[:change_net_percentage] = info
        elsif index % 4 == 3
          company[:share_volume] = info
          companies_info << company
        end
      end
    end


    #scrape links and add them to each company:
    links = doc.css("div##{selector} div.coName a").collect {|company| company.attr('href')}.uniq!
    companies_info.each do |company|
      company[:url] = links.first
      links.shift
    end

    companies_info
  end

  def self.scrape_unusual_volume

    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))

    companies = doc.css("div#UnusualVolume tr > td").children.reduce([]) do |accumulator, company|
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text.strip
      end
      accumulator
    end



    #turn acc into nested array:
    counter = 0
    subarray = []
    nested = companies.reduce([]) do |accumulator, info|
      if counter < 4
        subarray << info
        counter += 1
      elsif counter == 4
        subarray << info
        accumulator << subarray
        subarray = []
        counter = 0
      end
      accumulator
    end

    binding.pry

    companies_info = []
    nested.each do |company_group|
      company = {}
      company_group.each_with_index do |info, index|
        if index % 5 == 0
          company[:company_name] = info
        elsif index % 5 == 1
          company[:last_sale] = info
        elsif index % 5 == 2
          company[:change_net_percentage] = info
        elsif index % 5 == 3
          company[:share_volume] = info
        elsif index % 5 == 4
          company[:volume_percentage_change] = info
          companies_info << company
        end
      end
    end

    #scrape links and add them to each company:
    links = doc.css("div#UnusualVolume div.coName a").collect {|company| company.attr('href')}.uniq!
    companies_info.each do |company|
      company[:url] = links.first
      links.shift
    end
    companies_info

  end

  # END LIST METHODS

  #START: DETAIL METHODS

  def self.scrape_stock_details #(stock) #stock is an instance of Stock class
    stock_page = Nokogiri::HTML(open("http://www.nasdaq.com/symbol/gern"))  #should be stock.url
    stock_details_to_transform = stock_page.css("div.row.overview-results.relativeP div.table-row div.table-cell")

    transformed = transform(stock_details_to_transform)
    transformed.reduce({}) do |acc, attribute_pair|

      acc[attribute_pair[0].downcase.gsub(" ","_").to_sym] = attribute_pair[1]
      acc
    end

    # output:
    # {:"best_bid_/_ask"=>"$ 2.25 / $ 2.80", :"1_year_target"=>"3.75", :"today's_high_/_low"=>"$ 2.75 / $ 2.30", :share_volume=>"13,763,427", :"50_day_avg._daily_volume"=>"1,688,848", :previous_close=>"$ 2.35", :"52_week_high_/_low"=>"$ 3.15 / $ 1.74", :market_cap=>"402,856,489", :"p/e_ratio"=>"NE", :"forward_p/e_(1y)"=>"NE", :"earnings_per_share_(eps)"=>"$ -0.18", :annualized_dividend=>"N/A", :ex_dividend_date=>"N/A", :dividend_payment_date=>"N/A", :current_yield=>"0 %", :beta=>"0.6"}
    #

  end

  def self.transform(array)
    stock_details_array = []
    temp_arr = []

    array.each_with_index do |detail, index|
      temp_arr << detail.text.strip
      if index.odd? && index > 0
        stock_details_array << temp_arr
        temp_arr = []
      end
    end
    stock_details_array
  end


end
