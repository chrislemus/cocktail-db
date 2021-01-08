class CocktailDb::Data
  URL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f="
  def create_drinks
    drinks = fetch_all_drinks_by_alphabet
    drinks.each {|drink|
      CocktailDb::Drink.add_drink_from_hash(drink)
    }
  end

  def fetch_all_drinks_by_alphabet
    alphabet = ('a'..'z').to_a
    drinks = alphabet.map.with_index {|letter, idx| 
      show_progress(idx, alphabet.length)
      JSON.parse(self.api_request(URL + letter))['drinks'] 
    }
    show_progress
    drinks.compact.flatten
  end

  def show_progress(progress = 1, goal = 1)
    bar_length = 20
    percent = (progress.to_f/goal.to_f*100).ceil
    progress_bar = "=" * ((bar_length.to_f/100.to_f)*percent).ceil
    printf("\rLoading your drinks BOSS!: [%-#{bar_length}s] %d%%".green,progress_bar, percent)
    puts "\n\n" if progress == goal
  end

  def api_request(url)
    res = Net::HTTP.get_response(URI.parse(url))
    res.body
  end
end
