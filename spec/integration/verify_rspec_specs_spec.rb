require 'spec_helper'
require 'rspec/opal_rspec_spec_loader'
require 'rspec/core/core_spec_loader'

RSpec.describe 'RSpec' do
  context 'Core' do
    include Opal::RSpec::CoreSpecLoader

    it 'has specs run correctly' do
      name = :rspec_core_specs

      results           = execute_specs name
      puts results[:example_info]
      next
      parsed_results    = parse_results results
      summary           = parsed_results['summary']
      total             = summary['example_count']
      failed            = summary['failure_count']
      pending           = summary['pending_count']
      actual_failures   = parsed_results['examples'].select { |ex| ex['status'] == 'failed' }
      expected_failures = get_ignored_spec_failures
      used_exclusions   = []

      remaining_failures = actual_failures.reject do |actual|
        expected_failures.any? do |expected|
          exclusion = expected[:exclusion]
          actual_descr = actual['full_description']
          matches = case exclusion
                    when Regexp then exclusion.match actual_descr
                    when String then exclusion == actual_descr
                    else raise "Unknown filter expression type #{exclusion.class} in #{expected}!"
                    end
          used_exclusions << expected if matches
          matches
        end
      end
      each_header = '----------------------------------------------------'
      index = 0
      remaining_failures = remaining_failures.map do |example|
        index += 1
        [
          each_header,
          "Example #{index}: #{example['full_description']}",
          each_header,
          example['exception']['message']
        ].join "\n"
      end
      reasons = []
      reasons << 'Unexpected failures' unless remaining_failures.empty?
      reasons << "Expected #{expected_pending_count} pending but got #{pending}" unless pending == expected_pending_count
      reasons << 'no specs found' unless total > 0
      reasons << 'No failures, but Rake task did not succeed' if (failed == 0 && !results[:success])
      unused_exclusions = expected_failures.uniq - used_exclusions.uniq
      if unused_exclusions.any?
        msg = "WARNING: The following #{unused_exclusions.length} exclusion rules did not match an actual failure. Time to update exclusions? Duplicate exclusions??\n" +
            unused_exclusions.map { |e| "File: #{e[:filename]}\nLine #{e[:line_number]}\nFilter: #{e[:exclusion]}" }.join("\n---------------------\n")
        reasons << msg
      end
      passing = total - failed - pending
      percentage = ((passing.to_f / total) * 100).round(1)
      if reasons.empty?
        puts 'Test successful!'
        puts "#{total} total specs, #{failed} expected failures, #{pending} expected pending"
        puts "Passing percentage: #{percentage}%"
      else
        puts "Test FAILED for the following reasons:\n"
        puts reasons.join "\n\n"
        if remaining_failures.any?
          puts
          puts "Unexpected failures:\n\n#{remaining_failures.join("\n")}\n"
        end
        puts '-----------Summary-----------'
        puts "Total passed count: #{passing}"
        puts "Pending count #{pending}"
        puts "Total 'failure' count: #{actual_failures.length}"
        puts "Passing percentage: #{percentage}%"
        puts "Unexpected failure count: #{remaining_failures.length}"
        raise 'Test failed!'
      end
    end
  end
end
