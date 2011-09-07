require_relative 'movable_element'

module Sokoban
  class Man < Sokoban::MovableElement
    public_class_method :new

    def initialize(map, current_pos, state = :on_floor)
      @graph_obj = Sokoban::APP_CONFIG.elements['man']
      @storage_graph_obj = Sokoban::APP_CONFIG.elements['man_on_storage']
      super
    end

    def move(direction)
      new_pos = new_position(direction)
      if @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['crate'] ||
        @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['crate_on_storage']
        crate = Crate.new(@map, new_pos,
          @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['crate'] ?
            :on_floor : :on_storage)
        super if crate.move(direction)
      else
        super
      end
    end
  end
end

