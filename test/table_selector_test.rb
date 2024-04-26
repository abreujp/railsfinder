require_relative 'test_helper'

class TableSelectorTest < Minitest::Test
  def setup
    data = {'users' => '...', 'posts' => '...'}
    @selector = RailsFinder::TableSelector.new(data)
  end

  def test_initial_state
    assert_equal ['users', 'posts'], @selector.instance_variable_get(:@filtered_table_names)
  end

  def test_filter_data
    @selector.instance_variable_set(:@input, 'us')
    @selector.send(:update_filtered_tables)
    assert_equal ['users'], @selector.instance_variable_get(:@filtered_table_names)
  end

  def test_navigation
    @selector.instance_variable_set(:@selected_index, 0)
    @selector.send(:handle_keypress, "\e[B") # Simula pressionamento da seta para baixo
    assert_equal 1, @selector.instance_variable_get(:@selected_index)
  end
end
