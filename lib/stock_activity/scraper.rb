#require_relative '../stock_activity.rb'

class StockActivity::Scraper

def self.scrape(selector)
  doc = Nokogiri::HTML(open("https://www.nasdaq.com/"))
  companies =  doc.css("div\##{selector} tr > td").children.reduce([]) do |accumulator, company|
    if company.text.match(/[A-Z]|\d|unch/)
      accumulator << company.text.strip
    end
  accumulator
  end
#companies =
 #  ["Micron Technology, Inc. (MU)",
 # "$57.59",
 # "3 ▲ 5.50%",
 # "8,526,262",
 # "Oclaro, Inc. (OCLR)",
 # "$9.67",
 # "1.82 ▲ 23.18%",
 # "6,885,542",
 # "Intel Corporation (INTC)",
 # "$51.05",
 # "1.14 ▼ 2.18%",
 # "3,237,023",
 # "Apple Inc. (AAPL)",
 # "$181.03",
 # "1.05 ▲ 0.58%",
 # "2,276,539",
 # "Microsoft Corporation (MSFT)",
 # "$96.62",
 # "0.08 ▲ 0.08%",
 # "1,423,996"]

  if companies.count == 20 # ALL CATEGORIES EXCEPT UNUSUAL VOLUME

    nested = transform_array_to_nested_array(companies, 4)
#RETURNS a nested array:
 #    [["Facebook, Inc. (FB)", "$195.11", "8.22 ▲ 4.40%", "32,528,212"],
 # ["PayPal Holdings, Inc. (PYPL)", "$80.02", "5.30 ▼ 6.21%", "27,633,293"],
 # ["Microsoft Corporation (MSFT)", "$95.655", "0.65 ▲ 0.68%", "21,498,416"],
 # ["eBay Inc. (EBAY)", "$46.4775", "5.90 ▲ 14.53%", "18,418,237"],
 # ["VelocityShares Daily 2x VIX Short-Term ETN (TVIX)", "$5.72", "0.58 ▼ 9.21%", "14,940,614"]]
#
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

  elsif companies.count == 25 # UNUSUAL VOLUME

    nested = transform_array_to_nested_array(companies, 5)
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
# companies_info =
# [{:company_name=>"Micron Technology, Inc. (MU)", :last_sale=>"$57.66", :change_net_percentage=>"3.07 ▲ 5.62%", :share_volume=>"10,690,943"},
#  {:company_name=>"Oclaro, Inc. (OCLR)", :last_sale=>"$9.725", :change_net_percentage=>"1.88 ▲ 23.89%", :share_volume=>"8,110,173"},
#  ...]

  #scrape links and add them to each company:
  links = doc.css("div##{selector} div.coName a").collect {|company| company.attr('href')}.uniq!
  companies_info.each do |company|
    company[:url] = links.first
    links.shift
  end
  companies_info

  #FINAL RETURN VALUE: an array of hashes:
 #  [{:company_name=>"Facebook, Inc. (FB)",
 #  :last_sale=>"$195.11",
 #  :change_net_percentage=>"8.22 ▲ 4.40%",
 #  :share_volume=>"32,528,212",
 #  :url=>"https://www.nasdaq.com/symbol/fb"},
 # {:company_name=>"PayPal Holdings, Inc. (PYPL)",
 #  :last_sale=>"$80.02",
 #  :change_net_percentage=>"5.30 ▼ 6.21%",
 #  :share_volume=>"27,633,293",
 #  :url=>"https://www.nasdaq.com/symbol/pypl"}, ...
 #  ]

end

  # END LIST METHODS

  #START: DETAIL METHODS

  def self.scrape_stock_details(stock) #stock is an instance of Stock class

    stock_page = Nokogiri::HTML(open(stock.url))
    stock_details_to_transform = stock_page.css("div.row.overview-results.relativeP div.table-row div.table-cell")

    transformed = transform_array_to_nested_array(stock_details_to_transform, 2)
    stock.formatted_detail_pairs = transformed #FOR DISPLAYING PURPOSES: [[detail, value], [detail, value]...]
    go_from_array_to_hash(transformed)

  end

  def self.go_from_array_to_hash(transformed)
    #step 1. format the attribute to remove all special chars in order to create symbols
    copied_array = transformed.reduce([]) do |acc, attr_pair| #copy transformed and format the attribute to remove all special chars in order to create symbols
      new_string = attr_pair[0].downcase.gsub(/\s\/\s/, "_").gsub(/\s\/\s/, "_").gsub(/\s/, "_").gsub(/\d+_/, "").gsub(/\//, "").gsub(/\(/, "").gsub(/\)/, "").gsub(/\'/, "").gsub(/\./, "")
      acc << [new_string, attr_pair[1]]
    end

    #step 2. #create a hash {attr: value, attr: value, ... }
    copied_array.reduce({}) do |acc, attribute_pair|  #create a hash {attr: value, attr: value, ... }
      acc[attribute_pair[0].to_sym] = attribute_pair[1]
      acc
    end
  end

  def self.transform_array_to_nested_array(array, num)
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
