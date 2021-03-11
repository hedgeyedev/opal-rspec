require 'bundler'
require 'opal/sprockets'
Bundler.require

# bgbOpal::Processor.source_map_enabled = false

# run Opal::Server.new { |s|
run Opal::Sprockets::Server.new { |s|
  s.main = 'opal/rspec/sprockets_runner'
  s.append_path 'spec'
  s.debug = false
}
