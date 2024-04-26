# test/schema_parser_test.rb
require_relative 'test_helper'

class SchemaParserTest < Minitest::Test
  def test_parse_schema
    schema_content = "create_table \"users\" do |t|\n t.string 'name'\nend"
    expected_result = {'users' => "create_table \"users\" do |t|\n t.string 'name'\nend"}

    assert_equal expected_result, RailsFinder::SchemaParser.parse_schema(schema_content)
  end
end
