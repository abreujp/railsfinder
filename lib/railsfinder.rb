# frozen_string_literal: true

require_relative "railsfinder/version"
require_relative "railsfinder/interface"
require_relative "railsfinder/schema_loader"
require_relative "railsfinder/schema_parser"
require_relative "railsfinder/table_selector"

module Railsfinder
  class Error < StandardError; end
  # Your code goes here...
end
