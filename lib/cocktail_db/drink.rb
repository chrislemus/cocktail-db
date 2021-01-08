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

  def self.get_drinks_by_glass_type(glass_type)
    @@all.select {|drink| drink.glass == glass_type}
  end

  def self.get_drinks_by_category(category)
    @@all.select {|drink| drink.category == category}
  end

  def self.search_for_drink(search_query)
    @@all.select {|drink| drink.name.downcase.start_with?(search_query.downcase)}
  end
  
  def self.get_categories
    @@all.map {|drink| drink.category}.uniq
  end

  def self.get_glass_types
    @@all.map {|drink| drink.glass}.uniq
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
