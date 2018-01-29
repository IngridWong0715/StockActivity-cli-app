class StockActivity::CLI
  def call
    puts "Welcome to Stock Activities! Which kind of stock activity would you like to see?"
    start

  end

  def start
    puts "Please enter: most active, most advanced, most declined, dollar volume, or unusual volume"
    input = gets.strip.downcase

    if input == "most active"
      puts "scraping most active"
    elsif input == "most advanced"
      puts "scraping most advanced"
    elsif input == "most declined"
      puts "scraping  most declined"
    elsif input == "dollar volume"
      puts "dollar volume"
    elsif input == "unusual volume"
      puts "unusual volume"
    end
  end


end

#
# show options:
# 	- Most Active
# 	- Most Advanced
# 	- Most Declined
# 	- Dollar Volume
# 	- Unusual Volume
# User picks one option
# Display each company, last sasle, change net/%, share volume
