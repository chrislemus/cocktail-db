require_relative 'lib/cocktail_db/version'

Gem::Specification.new do |spec|
  spec.name          = "cocktail_db"
  spec.version       = CocktailDb::VERSION
  spec.authors       = ["chrislemus"]
  spec.email         = ["icrislemus@gmail.com"]

  spec.summary       = "search drinks/coctails by name, ingredients, and more"
  spec.description   = "get details for most cocktails(ingredients/instructions)"
  spec.homepage      = "https://github.com/chrislemus/cocktail-db"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chrislemus/cocktail-db"
  spec.metadata["changelog_uri"] = "https://github.com/chrislemus/cocktail-db"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'json'
end
