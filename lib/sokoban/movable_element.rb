module Sokoban
  class MovableElement
    private_class_method :new

    @@direction_list = {
        up: [-1, 0],
        down: [1, 0],
        right: [0, 1],
        left: [0, -1]
    }

    def initialize(map, current_pos, state = :on_floor)
      @map = map
      @current_pos = current_pos
      @current_graph = state == :on_storage ? @storage_graph_obj : @graph_obj
    end

    def move(direction)
      new_pos = new_position(direction)

      unless blocked?(new_pos)
        @map[new_pos[0]][new_pos[1]] =
            @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['storage'] ?
              @storage_graph_obj :
              @graph_obj
        @map[@current_pos[0]][@current_pos[1]] =
            @map[@current_pos[0]][@current_pos[1]] == @storage_graph_obj ?
              Sokoban::APP_CONFIG.elements['storage'] :
              Sokoban::APP_CONFIG.elements['empty']

        @current_pos = new_pos
        @current_graph = @map[new_pos[0]][new_pos[1]]
      end
    end

    def blocked?(new_pos)
      @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['wall'] ||
          @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['crate'] ||
          @map[new_pos[0]][new_pos[1]] == Sokoban::APP_CONFIG.elements['crate_on_storage']
    end

    def new_position(direction)
      new_pos = []
      @current_pos.zip(@@direction_list[direction]) { |elem| new_pos << elem.inject(:+)}
      new_pos
    end
  end
end

