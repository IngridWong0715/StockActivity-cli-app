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

    # companies.map! do |info|
    #   info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    # end

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
binding.pry
    # companies.map! do |info|
    #   #info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    #   info.strip
    # end

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
