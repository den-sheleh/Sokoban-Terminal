require 'yaml'
require 'ostruct'

require_relative 'game'
require_relative 'movable_element'
require_relative 'man'
require_relative 'crate'

module Sokoban
  Dir.chdir(File.dirname(__FILE__))
  app_config = YAML.load(File.open("../../config/config.yml"))
  APP_CONFIG = OpenStruct.new(app_config)

  class Runner
    def initialize(argv)
      Game.new(argv[0])
    end
  end
end

