# frozen_string_literal: true

#
# Add an initializer to pull in the Engine's locale yml files.
#
module Engineer
  module Locale
    class Initializers
      def self.add_engine_locale_files(app, engine_config)
        engine_locale_files = Dir[engine_config.root.join("config", "locales", "**", "*.{rb,yml}")]
        i18n = app.config.i18n
        i18n.load_path += engine_locale_files
        i18n.default_locale = "en-GB"
        i18n.fallbacks = [:en]
      end

      def initialize(klass)
        @klass = klass
      end

      def add
        klass.initializer :"add_locals_in_#{klass.name.underscore.tr("/", "_")}" do |app|
          # Because we have a different binding here we can't call private Initializers
          # members so instead explicitly call a class method on ourselves passing in the
          # variables we need.
          Engineer::Locale::Initializers.add_engine_locale_files(app, config)
        end
      end

      private

      attr_reader :klass
    end
  end
end
