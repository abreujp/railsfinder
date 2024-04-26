require 'tty-reader'
require 'tty-screen'
require 'tty-cursor'
require 'tty-box'

module RailsFinder
  class TableSelector
    def initialize(data)
      @data = data
      @filtered_table_names = data.keys
      @selected_index = 0
      @input = ''
    end

    def start
      loop do
        read_user_input
        break if @exit_requested
        render_layout
      end
    end

    private

    def read_user_input
      reader = TTY::Reader.new
      key = reader.read_keypress
      handle_keypress(key)
    end

    def handle_keypress(key)
      case key
      when "\e[A" # Up arrow
        @selected_index = (@selected_index - 1) % @filtered_table_names.length unless @filtered_table_names.empty?
      when "\e[B" # Down arrow
        @selected_index = (@selected_index + 1) % @filtered_table_names.length unless @filtered_table_names.empty?
      when "\r" # Enter
        # Detail action here
      when "\e" # Escape key
        @exit_requested = true
      when "\u007F", "\b" # Backspace
        @input.chop!
      else
        @input << key if key =~ /\A[\w\s]+\z/
      end

      update_filtered_tables
    end

    def update_filtered_tables
      @filtered_table_names = @data.keys.select { |name| name.downcase.include?(@input.downcase) }
      @selected_index = 0 if @filtered_table_names.empty?
    end

    def render_layout
      system "clear"
      puts TTY::Cursor.move_to(0, 0)
      draw_input_box
      draw_table_selection
      draw_details_panel
    end

    def draw_input_box
      left_panel_width = TTY::Screen.width / 2
      top_height = 3
      print TTY::Box.frame(
        top: 0,
        left: 0,
        width: left_panel_width,
        height: top_height,
        title: { top_left: ' Search ' },
        border: :light
      ) { @input }
    end

    def draw_table_selection
      screen_size = TTY::Screen.size
      left_panel_width = screen_size[1] / 2
      top_height = 3
      print TTY::Box.frame(
        top: top_height,
        left: 0,
        width: left_panel_width,
        height: screen_size[0] - top_height,
        title: { top_left: " Select Table: #{@selected_index + 1}/#{@filtered_table_names.length} " },
        border: :light
      ) { @filtered_table_names.map.with_index { |name, index| index == @selected_index ? "=> #{name}" : "   #{name}" }.join("\n") }
    end

    def draw_details_panel
      screen_size = TTY::Screen.size
      left_panel_width = screen_size[1] / 2
      right_panel_width = screen_size[1] - left_panel_width
      print TTY::Box.frame(
        top: 0,
        left: left_panel_width,
        width: right_panel_width,
        height: screen_size[0],
        title: { top_left: ' Details ' },
        border: :light
      ) { @data[@filtered_table_names[@selected_index]] || "" }
    end
  end
end
