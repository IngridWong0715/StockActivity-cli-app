require_relative '../stock_activity.rb'

class StockActivity::Scraper

def self.scrape(selector)
  doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))
  companies =  doc.css("div\##{selector} tr > td").children.reduce([]) do |accumulator, company|
    if company.text.match(/[A-Z]|\d|unch/)
      accumulator << company.text.strip
    end
  accumulator
  end

  if companies.count == 20

    nested = transform_to_nested(companies, 4)

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

  elsif companies.count == 25

    nested = transform_to_nested(companies, 5)
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

  end
  #scrape links and add them to each company:
  links = doc.css("div##{selector} div.coName a").collect {|company| company.attr('href')}.uniq!
  companies_info.each do |company|
    company[:url] = links.first
    links.shift
  end
  companies_info
end


  # END LIST METHODS

  #START: DETAIL METHODS

  def self.scrape_stock_details(stock) #stock is an instance of Stock class
    # url = stock.url
    stock_page = Nokogiri::HTML(open(stock.url))  #should be stock.url
    stock_details_to_transform = stock_page.css("div.row.overview-results.relativeP div.table-row div.table-cell")
    transformed = transform_to_nested(stock_details_to_transform, 2)

    stock.formatted_detail_pairs = transformed #FOR DISPLAYING PURPOSES

    copied_array = transformed.reduce([]) do |acc, attr_pair|
      new_string = attr_pair[0].downcase.gsub(/\s\/\s/, "_").gsub(/\s\/\s/, "_").gsub(/\s/, "_").gsub(/\d+_/, "").gsub(/\//, "").gsub(/\(/, "").gsub(/\)/, "").gsub(/\'/, "").gsub(/\./, "")
      acc << [new_string, attr_pair[1]]
    end

    copied_array.reduce({}) do |acc, attribute_pair|
      acc[attribute_pair[0].to_sym] = attribute_pair[1]
      acc
    end
  end

  def self.transform_to_nested(array, num)
    temp_array = []
    final_array = []
    array.each_with_index do |element, index|
      if element.class == String
        temp_array << element
      else
        temp_array << element.text.strip
      end

      if (index+1) % num == 0 && (index+1) > 0
        final_array << temp_array
        temp_array = []
      end
    end
    final_array
  end
end
