module RailsFinder
  class SchemaParser
    def self.parse_schema(schema_content)
      tables = {}
      schema_content.scan(/create_table ['"](.+?)['"](.+?)end/m).each do |table_name, table_content|
        tables[table_name] = format_table(table_name, table_content.strip)
      end
      tables
    end

    private

    def self.format_table(name, content)
      "create_table \"#{name}\" #{content}\nend"
    end
  end
end
