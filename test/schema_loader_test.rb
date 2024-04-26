# test/schema_loader_test.rb
require_relative 'test_helper'

class SchemaLoaderTest < Minitest::Test
  def setup
    @loader = RailsFinder::SchemaLoader.new
  end

  def test_load_schema_data_success
    File.stub :exist?, true do
      File.stub :read, "create_table 'users' do |t|\n t.string 'name'\nend" do
        RailsFinder::SchemaParser.stub :parse_schema, {'users' => "create_table 'users' do |t|\n t.string 'name'\nend"} do
          assert_equal({'users' => "create_table 'users' do |t|\n t.string 'name'\nend"}, @loader.load_schema_data)
        end
      end
    end
  end

  def test_load_schema_data_failure
    File.stub :exist?, false do
      assert_empty @loader.load_schema_data
    end
  end
end
