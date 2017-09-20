RSpec.configure do |config|
  expected_failures = [
    "RSpec::Core::ExampleGroup minimizes the number of methods that users could inadvertantly overwrite",
  ]
  config.filter_run_excluding :full_description => Regexp.union(expected_failures.map { |d| Regexp.new(d) })
end
