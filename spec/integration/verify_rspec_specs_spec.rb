require 'spec_helper'
require 'rspec/opal_rspec_spec_loader'

RSpec.describe 'RSpec specs:' do
  context 'Core' do
    include Opal::RSpec::OpalRSpecSpecLoader

    def short_name
      'core'
    end

    def files_with_line_continue
      [
        /core\/example_spec.rb/,
        /pending_spec.rb/,
      ]
    end

    def spec_glob
      ['rspec-core/spec/**/*_spec.rb',]
    end

    def stubbed_requires
      [
        'rubygems',
        'aruba/api', # Cucumber lib that supports file creation during testing, N/A for us
        'simplecov', # hooks aren't available on Opal
        'tmpdir',
        'rspec/support/spec/shell_out', # only does stuff Opal can't support anyways
        'rspec/support/spec/prevent_load_time_warnings'
      ]
    end

    def additional_load_paths
      [
        # 'rspec-core/spec' # a few spec support files live outside of rspec-core/spec/rspec and live in support
        # "#{__dir__}../../../lib-opal-spec-support",
        "lib-opal-spec-support",
      ]
    end

    it 'runs correctly' do
      results = run_specs
      failures = results.json[:examples].select { |ex| ex[:status] == 'failed' }

      unless failures.empty?
        puts "=========== Output of failed run ============"
        puts results.quoted_output
        puts "============================================="
      end

      expect(results.json[:summary_line]).to eq("726 examples, 0 failures, 113 pending")
      expect(failures).to eq([])
      expect(results).to be_successful
    end
  end

  # context 'Support' do
  #   include Opal::RSpec::OpalRSpecSpecLoader
  #
  #   def short_name
  #     'support'
  #   end
  #
  #   def files_with_line_continue
  #     [
  #       /core\/example_spec.rb/,
  #       /pending_spec.rb/,
  #     ]
  #   end
  #
  #   def spec_glob
  #     ["rspec-#{short_name}/spec/**/*_spec.rb",]
  #   end
  #
  #   def stubbed_requires
  #     [
  #       'rubygems',
  #       'aruba/api', # Cucumber lib that supports file creation during testing, N/A for us
  #       'simplecov', # hooks aren't available on Opal
  #       'tmpdir',
  #       'rspec/support/spec/shell_out', # only does stuff Opal can't support anyways
  #       'rspec/support/spec/prevent_load_time_warnings'
  #     ]
  #   end
  #
  #   def additional_load_paths
  #     [
  #       # 'rspec-core/spec' # a few spec support files live outside of rspec-core/spec/rspec and live in support
  #       # "#{__dir__}../../../lib-opal-spec-support",
  #       "lib-opal-spec-support",
  #     ]
  #   end
  #
  #   it 'runs correctly' do
  #     results = run_specs
  #     failures = results.json[:examples].select { |ex| ex[:status] == 'failed' }
  #
  #     unless failures.empty?
  #       puts "=========== Output of failed run ============"
  #       puts results.quoted_output
  #       puts "============================================="
  #     end
  #
  #     expect(results.json[:summary_line]).to eq("726 examples, 0 failures, 113 pending")
  #     expect(failures).to eq([])
  #     expect(results).to be_successful
  #   end
  # end
  #
end
