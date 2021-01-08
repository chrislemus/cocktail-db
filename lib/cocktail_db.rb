require "bundler/setup"
require "cocktail_db"
require "cocktail_db/version"
require 'net/http'
require 'open-uri'
require 'json'
require 'cocktail_db/drink'
require 'cocktail_db/cli'
require 'cocktail_db/data'

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bold;           "\e[1m#{self}\e[22m" end
  def blink;          "\e[5m#{self}\e[25m" end
end

module CocktailDb
  class Error < StandardError; end
  # Your code goes here...
end