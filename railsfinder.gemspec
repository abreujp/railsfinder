# frozen_string_literal: true

require_relative "lib/railsfinder/version"

Gem::Specification.new do |spec|
  spec.name = "railsfinder"
  spec.version = Railsfinder::VERSION
  spec.authors = ["jpstudioweb"]
  spec.email = ["jpaulo6ba@gmail.com"]

  spec.summary = "Search by table name in Rails db/schema.rb file and display its contents."
  spec.description = "This gem enables users to search and view details of tables defined in the schema.rb file of a Rails application."
  spec.homepage = "http://example.com/mygem" # Update with your actual homepage URL
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # Define metadata only if you have the actual URLs available
  # spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jpstudioweb/railsfinder"
  # spec.metadata['changelog_uri'] = "http://example.com/mygem/changelog"

  # Include all Ruby files in lib and all files in bin
  spec.files = Dir["lib/**/*.rb"] + Dir["bin/*"]
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.bindir = "bin"
  spec.require_paths = ["lib"]

  # Specify dependencies
  spec.add_dependency "tty-box", "~> 0.7"
  spec.add_dependency "tty-cursor", "~> 0.7"
  spec.add_dependency "tty-reader", "~> 0.9"
  spec.add_dependency "tty-screen", "~> 0.8"
  spec.add_development_dependency 'minitest', '~> 5.22'

  # More information and examples about creating a new gem are available at:
  # https://bundler.io/guides/creating_gem.html
end
