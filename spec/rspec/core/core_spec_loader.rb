require_relative '../opal_rspec_spec_loader'

module Opal
  module RSpec
    module CoreSpecLoader
      include Opal::RSpec::OpalRSpecSpecLoader
      extend self

      def expected_pending_count
        1
      end

      def short_name
        'core'
      end

      def base_dir
        'spec/rspec/core'
      end

      def files_with_line_continue
        [/core\/example_spec.rb/, /pending_spec.rb/]
      end

      def default_path
        'rspec-core/spec'
      end

      def spec_glob
        %w{rspec-core/spec/**/*_spec.rb spec/rspec/core/opal_alternates/**/*_spec.rb}
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
    end
  end
end
