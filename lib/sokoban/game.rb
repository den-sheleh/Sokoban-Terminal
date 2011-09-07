require_relative 'man'
require_relative 'crate'
require "highline/system_extensions"


module Sokoban
  class Game
    include HighLine::SystemExtensions

    def initialize(level)
      self.level = level
      run
    end

    private
    def level=(level = 1)
      @level = level.to_i
      @level = 1 unless @level > 0 && @level <= Sokoban::APP_CONFIG.game['levels_count']
    end

    def run
      load_map(@level)
      start
    end

    def start
      display_frame

      while key = get_character.chr
        case key
          when 'A' #up key
            @man_object.move(:up);
          when 'B' #down key
            @man_object.move(:down);
          when 'C'
            @man_object.move(:right);
          when 'D'
            @man_object.move(:left);
          when 'r'
            run
          when 'q'
            finish
        end

        next_level if finished?
        display_frame
      end
    end

    def load_map(level)
      reading_map = false
      empty_line_counter = 0

      @map = []
      row_num = 0
      col_num = 0
      current_pos = []

      Dir.chdir(File.dirname(__FILE__))
      File.open(Sokoban::APP_CONFIG.game['levels_source']) do |file|
        while line = file.gets.chop!
          if line.empty?
            break if reading_map
            empty_line_counter += 1
            next
          end

          if empty_line_counter == (level - 1) or reading_map
            row_arr = []
            col_num = 0
            line.each_char do |chr|
              if chr == Sokoban::APP_CONFIG.elements['man']
                current_pos[0], current_pos[1] = row_num, col_num
                @man_object = Man.new(@map, current_pos)
              end
              row_arr << chr
              col_num += 1
            end

            @map << row_arr
            row_num += 1
            reading_map = true
          end
        end
      end
    end

    def finished?
      !@map.flatten.any?{ |elem| elem == Sokoban::APP_CONFIG.elements['storage'] ||
        elem == Sokoban::APP_CONFIG.elements['crate'] ||
        elem == Sokoban::APP_CONFIG.elements['man_on_storage']  }
    end

    def display_frame
      clear_screen
      puts "Use arrows to move.\nPress 'q' for quit.\nPress 'r' to restart\n\n" +
        @map.map { |row| row.join }.join("\n") + "\n"
    end

    def next_level
      display_frame
      puts "\n\nCongratulation. You have solved level ##{@level} =)\n\n"
      next_level = @level + 1
      if next_level > Sokoban::APP_CONFIG.game['levels_count']
        puts "\n\n******** Congratulation. You have solved all levels =) ********\n\n "
      end

      puts "Are you want to go on the next level ? (Y|n)"
      choice = STDIN.getc
      choice == 'n' ? finish : initialize(next_level)
    end

    def finish
      puts "\n\nThank you for being with us =)\n\n"
      exit
    end

    def clear_screen
      RUBY_PLATFORM =~ /mswin|mingw/ ? system('cls') : system('clear')
    end
  end
end

