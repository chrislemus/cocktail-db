require 'pry'
class CocktailDb::CLI
  URL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=m"
  attr_reader :results_per_page
  def initialize
    @results_per_page = 10
  end
  def get_tipsy
    puts 'WELCOME TO COCKTAIL DB!'.cyan.blink
    CocktailDb::Data.new.create_drinks  
    user_input = nil
    print_header 
    until user_input == 'exit'
      
      user_input = gets.strip
      main_method_called = user_input.to_i.between?(2,5)
      print_header if !main_method_called
      case user_input
      when '1';  get_drinks_count
      when '2';  list_all_drinks; 
      when '3';  search_for_drink; 
      when '4'; list_all_drink_categories; 
      when '5'; list_all_drink_glass_types
      when 'menu'; print_navigation
      else
        if user_input == 'exit'
          p('GOODBYE...')
        else
          p('invalid input', 'red') 
        end
      end
      print_header if main_method_called
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

  #prints string with styling
  def p(string, text_color = 'cyan') 
    string = string.to_s if !string.is_a? String
    puts string.send(text_color)
  end

  def print_navigation
    p('1 - Get drink count')
    p('2 - List all drinks')
    p('3 - Search for drink')
    p('4 - list all drink categories')
    p('5 - list all glass types for drinks')
    p('exit - exits program')
  end

  def list_all_drinks
    drinks = CocktailDb::Drink.all
    page_results(drinks, "Drinks List", 'drink info')
  end

  def list_drinks_with_filter(filter_type, filter_param)
    drinks = nil
    case filter_type
    when 'Glass types'
      drinks = CocktailDb::Drink.get_drinks_by_glass_type(filter_param)
    when 'Categories'
      drinks = CocktailDb::Drink.get_drinks_by_category(filter_param)
    end

    header = "#{filter_type} ► #{filter_param} ► Drinks"
    page_results(drinks, header, 'drink info')
  end

  def page_results(results, results_title, data_type)
    user_input = nil 
    sub_head = "n - next page | p - previous page | bb - go back \n*enter item number to get #{data_type}"
    page_number = 1
    results_text = data_type != 'drink info' ? results : results.map{|drink| drink.name}
    number_of_pages = (results.length.to_f/@results_per_page.to_f).ceil
    until user_input == 'bb'
      print_header(false, results_title, sub_head)
      print_page_results(page_number, results_text)
      p("-- PAGE #{page_number} of #{number_of_pages} --", 'cyan')
      user_input = gets.strip
      case user_input
      when 'n'
        (page_number+1).between?(1,number_of_pages) ? page_number+=1 : p('no page to show, please try again', 'red')
      when 'p'
        (page_number-1).between?(1,number_of_pages) ? page_number-=1 : p('no page to show, please try again', 'red')
      else
        #user has selected a drink
        if user_input.to_i.between?(1,results.length)
          user_selection = results[(user_input.to_i)-1]
          case data_type
          when 'drink info'; display_drink_info(user_selection, results_title)
          when 'drinks by category'; list_drinks_with_filter(results_title, user_selection) 
          when 'drinks by glass type'; list_drinks_with_filter(results_title, user_selection) 
          end
        elsif  user_input != 'bb'
          puts 'invalid input'.red
        end
      end
    end
  end

  def print_page_results(page_number, results)
    first_item_idx = (page_number * @results_per_page) - @results_per_page
    current_page_results = results.slice(first_item_idx, @results_per_page)
    current_page_results.each_with_index{|item, idx| 
      item_list_number = first_item_idx + 1 + idx
      p("#{item_list_number}. #{item}", 'green')
    }
  end

  def list_all_drink_glass_types
    page_results(CocktailDb::Drink.get_glass_types, "Glass types", "drinks by glass type")
  end

  def list_all_drink_categories
    page_results(CocktailDb::Drink.get_categories, "Categories", "drinks by category")
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


  def search_for_drink
    header = 'Search for drink'
    print_header(false, header, 'bb - go back')
    p('**search drinks by name, entire name not require just first few letters work.', 'cyan')
    user_input = gets.strip
    results = CocktailDb::Drink.search_for_drink(user_input)
    unless user_input == 'bb'
      if results.length > 0
        page_results(results, header + ": '#{user_input}'", 'drink info')
      else
        p('no results found please try again', 'red')
      end
      search_for_drink
    end
  end
end
