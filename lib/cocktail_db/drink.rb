class CocktailDb::Drink
  DRINK_PROPERTIES = ['strDrink', 'strAlcoholic', 'strGlass', 'strInstructions', 'strCategory']
  attr_accessor :name, :ingredients, :category, :alcoholic, :contains_alcohol, :glass, :instructions
  @@all = []
  def initialize(name, ingredients=nil, category=nil, alcoholic=nil, glass=nil, instructions=nil)
    @name = name
    @ingredients = ingredients
    @category = category
    @alcoholic = alcoholic
    @glass = glass
    @instructions = instructions
  end

  def self.add_drink_from_hash(drink)
    name, alcoholic, glass, instructions, category = DRINK_PROPERTIES.map{|prop| drink[prop]}
    ingredients = sort_ingredients(drink)
    new_drink = self.new(name, ingredients, category, alcoholic, glass, instructions)
    new_drink.save
  end

  def self.search_for_drink(drink_name)
    @@all.select {|drink| drink.name.downcase.start_with?(drink_name.downcase)}
  end

  def save
    @@all << self
  end

  def self.all
    @@all 
  end

  def self.sort_ingredients(drink)
    ingredients = drink.select {|k,v| k.start_with?('strIngredient')}.values.compact
    measurements = drink.select {|k,v| k.start_with?('strMeasure')}.values.compact
    ingredients.zip(measurements)
  end

end

#strDrink = name
#strCategory = category
#strAlcoholic = contains_alcohol
#strGlass = glass
#strInstructions = instructions
#strDrinkThumb = image_link

#   "strDrink"=>"A1", name
#   "strCategory"=>"Cocktail", category
#   "strAlcoholic"=>"Alcoholic", contains_alcohol
#   "strGlass"=>"Cocktail glass", glass
#   "strInstructions"=>"Pour all ingredients into a cocktail shaker, mix and serve over ice into a chilled glass.", instructions
#   "strDrinkThumb"=>"https://www.thecocktaildb.com/images/media/drink/2x8thr1504816928.jpg", image_link

#   []
#   "strIngredient1"=>"Gin",
#   "strIngredient2"=>"Grand Marnier",
#   "strIngredient3"=>"Lemon Juice",
#   "strIngredient4"=>"Grenadine",
#   "strMeasure1"=>"1 3/4 shot ",
#   "strMeasure2"=>"1 Shot ",
#   "strMeasure3"=>"1/4 Shot",
#   "strMeasure4"=>"1/8 Shot",
