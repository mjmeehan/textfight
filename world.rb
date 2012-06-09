class World
  
  def self.instance
    @instance ||= World.new
    @instance
  end

  # Places the user on the map
  def join(fighter)
    @fighters << fighter

    push_map
  end

  def starting_location!
    @start_coords.pop
  end

  def fighter_moved
    push_map
  end

  def render
    push_map
  end
  
  private

    Dimension = 10
    Min_Coord = 0
    Max_Coord = Dimension-1

    def initialize
      @fighters ||= []
      @start_coords = [[Min_Coord,Min_Coord], [Max_Coord,Max_Coord]]
    end

    # Returns string of the state of the world.
    def map
      state_text = ""

      Dimension.times do |x|
        Dimension.times do |y|
          state_text += " #{render_cell(x,y)} "

          # Border between cells
          state_text += "|" if y < Max_Coord
        end

        # Spacer text between rows
        state_text << row_sep if x < Max_Coord
      end

      state_text
    end

    def row_sep
      text = "\n"
      39.times { text += "-" }
      text += "\n"
    end

    def push_map
      @fighters.each do |fighter|
        fighter.connection.puts blank_lines
        fighter.connection.puts map
      end
    end

    def blank_lines
      blank_lines = ""
      15.times { blank_lines += "\n" }
      blank_lines
    end

    def render_cell(x,y)
      case num_fighters_in_cell(x,y)
      # Two fighters in the cell, so we display a !.
      when 2
        "!"

      # One fighter in the cell.
      when 1
        fighter_icon_at(x,y)

      # No fighters, so this is a blank cell.
      when 0
        " "
      end
    end

    def fighter_icon_at(x, y)
      fighter_in_cell =
        @fighters.select {|fighter| fighter.located_here?(x, y)}.first

      fighter_in_cell.icon
    end

    def num_fighters_in_cell(x,y)
      count = 0

      @fighters.each do |fighter|
        count +=1 if fighter.located_here?(x, y)
      end

      count
    end
end

