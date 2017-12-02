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
      [
        # 'rspec-core/spec/rspec/core/backtrace_formatter_spec.rb',
        'rspec-core/spec/rspec/core/configuration_options_spec.rb',
        'rspec-core/spec/rspec/core/configuration_spec.rb',
        'rspec-core/spec/rspec/core/drb_spec.rb',
        'rspec-core/spec/rspec/core/dsl_spec.rb',
        'rspec-core/spec/rspec/core/example_execution_result_spec.rb',
        'rspec-core/spec/rspec/core/example_group_constants_spec.rb',
        'rspec-core/spec/rspec/core/example_group_spec.rb',
        'rspec-core/spec/rspec/core/example_spec.rb',
        'rspec-core/spec/rspec/core/failed_example_notification_spec.rb',
        'rspec-core/spec/rspec/core/filter_manager_spec.rb',

        'rspec-core/spec/rspec/core/formatters/base_text_formatter_spec.rb',
        'rspec-core/spec/rspec/core/formatters/console_codes_spec.rb',
        # 'rspec-core/spec/rspec/core/formatters/deprecation_formatter_spec.rb',
        # 'rspec-core/spec/rspec/core/formatters/documentation_formatter_spec.rb',
        # 'rspec-core/spec/rspec/core/formatters/helpers_spec.rb',
        # 'rspec-core/spec/rspec/core/formatters/html_formatter_spec.rb',
        'rspec-core/spec/rspec/core/formatters/json_formatter_spec.rb',
        'rspec-core/spec/rspec/core/formatters/profile_formatter_spec.rb',
        # 'rspec-core/spec/rspec/core/formatters/progress_formatter_spec.rb',
        # 'rspec-core/spec/rspec/core/formatters/snippet_extractor_spec.rb',

        # 'rspec-core/spec/rspec/core/formatters_spec.rb',
        'rspec-core/spec/rspec/core/hooks_filtering_spec.rb',
        'rspec-core/spec/rspec/core/hooks_spec.rb',
        'rspec-core/spec/rspec/core/memoized_helpers_spec.rb',
        'rspec-core/spec/rspec/core/metadata_filter_spec.rb',
        'rspec-core/spec/rspec/core/metadata_spec.rb',
        'rspec-core/spec/rspec/core/notifications_spec.rb',
        # 'rspec-core/spec/rspec/core/option_parser_spec.rb',
        # 'rspec-core/spec/rspec/core/ordering_spec.rb',
        'rspec-core/spec/rspec/core/pending_example_spec.rb',
        'rspec-core/spec/rspec/core/pending_spec.rb',
        # 'rspec-core/spec/rspec/core/project_initializer_spec.rb',
        # 'rspec-core/spec/rspec/core/rake_task_spec.rb',
        'rspec-core/spec/rspec/core/random_spec.rb',
        'rspec-core/spec/rspec/core/reporter_spec.rb',

        'rspec-core/spec/rspec/core/rspec_matchers_spec.rb',
        # 'rspec-core/spec/rspec/core/ruby_project_spec.rb',
        'rspec-core/spec/rspec/core/runner_spec.rb',
        'rspec-core/spec/rspec/core/shared_context_spec.rb',
        'rspec-core/spec/rspec/core/shared_example_group_spec.rb',
        'rspec-core/spec/rspec/core/warnings_spec.rb',
        'rspec-core/spec/rspec/core/world_spec.rb',

        # 'rspec-core/spec/**/*_spec.rb',
        # 'spec/rspec/core/opal_alternates/**/*_spec.rb',
      ]
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
        puts "FAILED:"
        puts results.quoted_output
      end

      expect(results.json[:summary_line]).to eq("652 examples, 0 failures, 94 pending")
      expect(failures).to eq([])
      expect(results).to be_successful
    end
  end
end
