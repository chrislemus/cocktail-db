require 'pry'
class CocktailDb::CLI
  URL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=m"
  # attr_reader :header
  # def initialize
    
  # end
  def get_tipsy
    puts 'WELCOME TO COCKTAIL DB!'.cyan.blink
    CocktailDb::Data.new.create_drinks  
    user_input = nil
    print_header 
    until user_input == 'exit'
      user_input = gets.strip
      print_header if !user_input.to_i.between?(1,3)
      case user_input
      when '1';  get_drinks_count
      when '2';  list_all_drinks; print_header
      when '3';  search_for_drink; print_header
      when 'menu'; print_navigation
      else
        if user_input == 'exit'
          p('GOODBYE...')
        else
          p('invalid input', 'red') 
        end
      end
    end
  end

  def get_drinks_count
    p("there are #{CocktailDb::Drink.all.length} drinks in database", 'green')
  end

  def print_header(is_home=true, header=false, sub_head = false)
    header  = header ? " Home ► #{header}": "        Home        " 
    if is_home
      header = "        Home        " 
      sub_head = "menu - loads menu"
    end
    puts header.bg_cyan.bold
    p(sub_head) if sub_head
  end

  def p(string, text_color = 'cyan') #prints string with styling
    string = string.to_s if !string.is_a? String
    puts string.send(text_color)
  end

  def print_navigation
    p('1 - Get drink count')
    p('2 - List all drinks')
    p('3 - Search for drink')
    p('exit - exits program')
  end

  def list_all_drinks
    drinks = get_sorted_drinks.map.with_index {|drink, idx| "#{idx+1}. #{drink.name}"}
    page_results(get_sorted_drinks, "Drinks List", true)
  end

  def page_results(items_array, results_title, items_are_drinks=false)
    user_input = nil 
    results_per_page = 10
    sub_head = 'next - next page | prev - previous page | home - go home'
    page_number = 1
    
    item_names_numbered_list = items_array.map.with_index {|item, idx| "#{idx+1}. #{item.name}"} 
    number_of_pages = (items_array.length.to_f/results_per_page.to_f).ceil
    until user_input == 'home'
      header = "#{results_title} (#{page_number} of #{number_of_pages})"
      print_header(false, header, sub_head)
      p('**enter drink number to get drink info')
      print_page_results(page_number, results_per_page, item_names_numbered_list)
      user_input = gets.strip
      case user_input
      when 'next'
        (page_number+1).between?(1,number_of_pages) ? page_number+=1 : p('no page to show, please try again', 'red')
      when 'prev'
        (page_number-1).between?(1,number_of_pages) ? page_number-=1 : p('no page to show, please try again', 'red')
      else
        #user has selected a drink
        if items_are_drinks && user_input.to_i.between?(1,items_array.length)
          display_drink_info(items_array[(user_input.to_i)-1], results_title)
        elsif  user_input != 'home'
          puts 'invalid input'.red
        end
      end
    end
  end

  def print_page_results(page_number, results_per_page, item_names_numbered_list)
    first_item_idx = (page_number * results_per_page) - results_per_page
    current_page_results = item_names_numbered_list.slice(first_item_idx, results_per_page)
    current_page_results.each{|item| p(item, 'green')}
  end

  def display_drink_info(drink, header)
    ingredients = drink.ingredients.map{|i| "∙ #{i[0]}: #{i[1]}"}.join("\n")
    print_header(false, header + " ► #{drink.name} ", "press 'Enter' to go back")
    drink_info  = [
      "name: #{drink.name}", 
      "alcoholic: #{drink.alcoholic}",
      "category: #{drink.category}",
      "glass: #{drink.glass}",
      "\ninstructions:\n#{drink.instructions}\n",
      "ingredients:\n#{ingredients}"
    ]
    drink_info.each{|info| p(info, 'green')}
    gets.strip
  end

  def get_sorted_drinks
    CocktailDb::Drink.all.sort { |a, b| a.name <=> b.name }
  end

  def search_for_drink
    header = 'Search for drink'
    print_header(false, header, 'home - go home')
    p('**search drinks by name, entire name not require just first few letters work.', 'cyan')
    user_input = gets.strip
    results = CocktailDb::Drink.search_for_drink(user_input)
    unless user_input == 'home'
      if results.length > 0
        page_results(results, header + ": '#{user_input}'", true)
      else
        p('no results found please try again', 'red')
        search_for_drink
      end
    end
  end

  def get_drinks
    uri = URI.parse(URL)
    response = Net::HTTP.get_response(uri)
    response.body
  end
end
