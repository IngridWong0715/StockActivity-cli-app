# REMARQUE:
# refactor most active - dollar Volume
# keep unusual volume: has one additional column: volume_percentage_change

require_relative '../stock_activity.rb'
class StockActivity::Scraper

  # def self.get_page
  #   Nokogiri::HTML(open("http://www.nasdaq.com/"))
  # end

  def self.scrape_most_active
    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))

    all = doc.css("div#Mostactive tr > td").children

    acc = all.reduce([]) do |accumulator, company|
      #binding.pry
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text
      end
      accumulator
    end


    acc.map! do |info|
      info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    end



    #turn acc into nested array:
    counter = 0
    subarray = []
    nested = acc.reduce([]) do |accumulator, info|
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

    companies_info


  end

  def self.scrape_most_advanced
    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))

    all = doc.css("div#Advancers tr > td").children

    acc = all.reduce([]) do |accumulator, company|
      #binding.pry
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text
      end
      accumulator
    end


    acc.map! do |info|
      info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    end



    #turn acc into nested array:
    counter = 0
    subarray = []
    nested = acc.reduce([]) do |accumulator, info|
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

    companies_info



  end

  def self.scrape_most_declined

    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))

    all = doc.css("div#Decliners tr > td").children

    acc = all.reduce([]) do |accumulator, company|
      #binding.pry
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text
      end
      accumulator
    end


    acc.map! do |info|
      info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    end



    #turn acc into nested array:
    counter = 0
    subarray = []
    nested = acc.reduce([]) do |accumulator, info|
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

    companies_info

  end

  def self.scrape_dollar_volume

    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))

    all = doc.css("div#DollarVolume tr > td").children

    acc = all.reduce([]) do |accumulator, company|
      #binding.pry
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text
      end
      accumulator
    end


    acc.map! do |info|
      info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    end



    #turn acc into nested array:
    counter = 0
    subarray = []
    nested = acc.reduce([]) do |accumulator, info|
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

    companies_info

  end

  def self.scrape_unusual_volume

    doc = Nokogiri::HTML(open("http://www.nasdaq.com/"))

    all = doc.css("div#UnusualVolume tr > td").children

    acc = all.reduce([]) do |accumulator, company|
      #binding.pry
      if company.text.match(/[A-Z]|\d|unch/)
        accumulator << company.text
      end
      accumulator
    end


    acc.map! do |info|
      info.include?("\r") ? info.scan(/[A-Z].*\)/).first : info
    end



    #turn acc into nested array:
    counter = 0
    subarray = []
    nested = acc.reduce([]) do |accumulator, info|
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

    companies_info

  end

end
