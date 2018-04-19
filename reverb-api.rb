require 'httparty'
require 'json'

class ReverbSearch

  def category_search
    print "ENTER A CATEGORY NAME: "

    user_cat = gets.chomp.capitalize

    options = {
      headers: { "Accept": "application/hal+json",
               "content-type": "application/json",
               "Accept-Version": "3.0",
               "cache-control": "max-age=86400, public"
             }
           }

    response =  HTTParty.get('https://api.reverb.com/api/categories/flat', options)
    category_name = JSON.parse(response.body)['categories']

    categories = category_name.map { |x| x['full_name'] }
    no_slash_cat = categories.map { |cat| cat.split('/').join }

    compare = no_slash_cat.select { |x| x.include?(user_cat) }

    if compare.empty?
      puts "Your search for #{user_cat} returned no results."
    else
      puts compare.map { |x| x.gsub(/\s{2,}/, ' - ') }
    end
  end


  def search_listings
    print "Enter '1' to see all listings. Enter '2' for listings in a category: "

    user_search = gets.chomp.to_i

    options = {
      headers: { "Accept": "application/hal+json",
               "content-type": "application/json",
               "Accept-Version": "3.0",
               "cache-control": "max-age=0, private, must-revalidate"
             }
           }
    response = HTTParty.get('https://api.reverb.com/api/listings/all?page=1&per_page=10', options)
    all_search_listings = JSON.parse(response.body)
    category_listings = JSON.parse(response.body)['categories']
    parsed_listing = category_search

    if user_search == 1
      puts all_search_listings
    elsif user_search == 2
      parsed_listing
    else
      puts "You entered an invalid response"
    end
  end
end

my_reverb_search = ReverbSearch.new
puts my_reverb_search.category_search
puts my_reverb_search.search_listings
