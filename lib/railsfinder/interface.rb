require "tty-reader"
require "tty-screen"
require "tty-cursor"
require "tty-box"

module RailsFinder
  class Interface
    SCHEMA_FILE_PATH = "db/schema.rb"

    def self.start
      reader = TTY::Reader.new
      cursor = TTY::Cursor
      screen_size = TTY::Screen.size
      selected_index = 0
      data = load_schema_data
      table_names = data.keys
      filtered_table_names = table_names.dup
      input = ""

      render_layout(cursor, screen_size, filtered_table_names, selected_index, data, input)

      begin
        loop do
          key = reader.read_keypress
          case key
          when "\e[A" # Up arrow
            selected_index = (selected_index - 1) % filtered_table_names.length unless filtered_table_names.empty?
          when "\e[B" # Down arrow
            selected_index = (selected_index + 1) % filtered_table_names.length unless filtered_table_names.empty?
          when "\r" # Enter
            # Detail action
          when "\e" # Escape key
            break  # Exit the loop, which will end the program
          when "\u007F", "\b" # Backspace
            input.chop!
          else
            input << key if key =~ /\A[\w\s]+\z/
          end

          filtered_table_names = table_names.select { |name| name.downcase.include?(input.downcase) }
          selected_index = 0 if filtered_table_names.empty?

          render_layout(cursor, screen_size, filtered_table_names, selected_index, data, input)
        end
      rescue TTY::Reader::InputInterrupt
        system "clear"
        puts "\nBye"
        exit
      ensure
        system "clear"
        puts "\nExiting RailsFinder..."
      end
    end

    def self.render_layout(cursor, screen_size, filtered_table_names, selected_index, data, input)
      system "clear"
      left_panel_width = screen_size[1] / 2
      right_panel_width = screen_size[1] - left_panel_width
      top_height = 3

      puts cursor.move_to(0, 0)
      print TTY::Box.frame(
        top: 0,
        left: 0,
        width: left_panel_width,
        height: top_height,
        title: { top_left: " Search " },
        border: :light,
      ) { input }

      print TTY::Box.frame(
        top: top_height,
        left: 0,
        width: left_panel_width,
        height: screen_size[0] - top_height,
        title: { top_left: " Select Table: #{selected_index + 1}/#{filtered_table_names.length} " },
        border: :light,
      ) { filtered_table_names.map.with_index { |name, index| index == selected_index ? "=> #{name}" : "   #{name}" }.join("\n") }

      print TTY::Box.frame(
        top: 0,
        left: left_panel_width,
        width: right_panel_width,
        height: screen_size[0],
        title: { top_left: " Details " },
        border: :light,
      ) { data[filtered_table_names[selected_index]] || "" }
    end

    def self.load_schema_data
      schema_path = find_schema_file
      return {} unless schema_path && File.exist?(schema_path)

      schema_content = File.read(schema_path)
      parse_schema(schema_content)
    end

    def self.find_schema_file
      # Attempts to locate the db/schema.rb file in the current directory
      current_dir = Dir.pwd
      schema_file = File.join(current_dir, SCHEMA_FILE_PATH)

      File.exist?(schema_file) ? schema_file : nil
    end

    def self.parse_schema(schema_content)
      tables = {}

      # Adjust the scan to use capture parentheses correctly
      schema_content.scan(/create_table "(.+?)"(.+?)end/m).each do |capture|
        table_name = capture[0]
        table_content = capture[1].strip
        # Adds "\nend" to ensure 'end' is on a new line.
        tables[table_name] = "create_table \"#{table_name}\"#{table_content}\nend"
      end

      tables
    end
  end
end
