# frozen_string_literal: true

require_relative "./append_engine_paths"

module Engineer
  module Database
    class Initializers
      attr_reader :klass

      def initialize(klass)
        @klass = klass
      end

      def add
        klass.initializer :"append_migrations_in_#{klass.name.underscore.tr("/", "_")}" do |app|
          AppendEnginePaths.new(app: app, engine_config: config).call
        end
      end
    end
  end
end
