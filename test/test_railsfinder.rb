# frozen_string_literal: true

require "test_helper"

class TestRailsfinder < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Railsfinder::VERSION
  end
end
