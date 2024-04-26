module RailsFinder
  class SchemaLoader
    SCHEMA_FILE_PATH = "db/schema.rb"

    def load_schema_data
      schema_path = find_schema_file
      return {} unless schema_path && File.exist?(schema_path)

      schema_content = File.read(schema_path)
      SchemaParser.parse_schema(schema_content)
    end

    private

    def find_schema_file
      schema_file = File.join(Dir.pwd, SCHEMA_FILE_PATH)
      File.exist?(schema_file) ? schema_file : nil
    end
  end
end
