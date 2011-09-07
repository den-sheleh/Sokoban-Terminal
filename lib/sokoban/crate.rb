require_relative 'movable_element'

module Sokoban
  class Crate < Sokoban::MovableElement
    public_class_method :new

    def initialize(map, current_pos, state = :on_floor)
      @graph_obj = Sokoban::APP_CONFIG.elements['crate']
      @storage_graph_obj = Sokoban::APP_CONFIG.elements['crate_on_storage']
      super
    end
  end
end

