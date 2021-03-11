require 'opal/rspec'

module Opal
  module RSpec
    class RakeTask
      include Rake::DSL if defined? Rake::DSL

      RUNNER = File.expand_path('../../../../vendor/spec_runner.js', __FILE__)
      PORT = 9999
      URL = "http://localhost:9999/"

      def initialize(name = 'opal:rspec', &block)
        desc "Run opal specs in phantomjs"
        task name do
          require 'rack'
          require 'webrick'

          app = Opal::Server.new { |s|
            s.main = 'opal/rspec/sprockets_runner'
            s.append_path 'spec'
            s.debug = false

            block.call s if block
          }
          
          server = Thread.new do
            Thread.current.abort_on_exception = true
            Rack::Server.start(
              :app => app,
              :Port => PORT,
              :AccessLog => [],
              :Logger => WEBrick::Log.new("/tmp/server.out"),
            )
          end

          begin
            # sleep 1 if RUBY_PLATFORM =~ /linux/
            puts "\nSLEEPING 4"
            sleep 4
            puts "running phantomjs"
            puts %Q{phantomjs #{RUNNER} "#{URL}"}
            system %Q{phantomjs #{RUNNER} "#{URL}"}
            success = $?.success?
            puts "DONE with phantomjs success = #{success}" 

            exit 1 unless success
          ensure
            server.kill
          end
        end
      end
    end
  end

  module RSpec
    class RakeTask2
      include Rake::DSL if defined? Rake::DSL

      RUNNER = File.expand_path('../../../../vendor/spec_runner.js', __FILE__)
      PORT = 9999
      URL = "http://localhost:9999/"

      def initialize(name = 'opal:rspec_server', &block)
        desc "Run opal specs in phantomjs"
        task name do
          require 'rack'
          require 'webrick'

          app = Opal::Server.new { |s|
            s.main = 'opal/rspec/sprockets_runner'
            s.append_path 'spec'
            s.debug = false

            block.call s if block
          }
          
          server = Thread.new do
            Thread.current.abort_on_exception = true
            Rack::Server.start(
              :app => app,
              :Port => PORT,
              :AccessLog => [],
              :Logger => WEBrick::Log.new("/dev/null"),
            )
          end

          begin
            # sleep 1 if RUBY_PLATFORM =~ /linux/
            puts "\nSLEEPING 4"
            sleep 4
            puts "running phantomjs"
            puts %Q{phantomjs #{RUNNER} "#{URL}"}
            system %Q{phantomjs #{RUNNER} "#{URL}"}
            success = $?.success?
            puts "DONE with phantomjs success = #{success}" 

            exit 1 unless success
          ensure
            server.kill
          end
        end
      end
    end
  end
  
end

