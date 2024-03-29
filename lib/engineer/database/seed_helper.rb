# frozen_string_literal: true

require "csv"

module Engineer
  module Database
    module SeedHelper
      def log(msg, type: :full, &block)
        case type
        when :full
          print "-----> #{msg}"
          if block
            ms = Benchmark.ms(&block)
            milliseconds = "#{ms.to_i}ms"
            print "\r-----> #{milliseconds.ljust(8, ' ')} #{msg}"
          end
          print "\n"
        when :sub
          puts "                #{msg}"
        else
          raise "Unknown type #{type}"
        end
      end

      def log_section(title)
        log "-" * 80
        log title
        log "-" * 80
      end

      def without_papertrail_versioning_for(klass)
        raise ArgumentError unless klass.is_a? Class

        klass.paper_trail.disable
        yield
        klass.paper_trail.enable
      end

      def without_papertrail
        PaperTrail.disable if defined?(PaperTrail)
        yield if block_given?
        PaperTrail.enable if defined?(PaperTrail)
      end
    end
  end
end
