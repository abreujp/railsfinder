require_relative 'table_selector'
require_relative 'schema_loader'

module RailsFinder
  class Interface
    def self.start
      schema_loader = SchemaLoader.new
      data = schema_loader.load_schema_data
      table_selector = TableSelector.new(data)
      table_selector.start
    end
  end
end
