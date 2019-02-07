# frozen_string_literal: true

#
# Add an initializer to pull in the Engine's locale yml files.
#
module Engineer
  module Locale
    class Initializers
      def initialize(klass)
        @klass = klass
      end

      # rubocop:disable Metrics/AbcSize
      def setup_locales
        klass.initializer :"add_locals_in_#{klass.name.underscore.tr("/", "_")}" do |app|
          glob = Dir[config.root.join("config", "locales", "**", "*.{rb,yml}")]
          app.config.i18n.load_path += glob
          app.config.i18n.default_locale = "en-GB"
          app.config.i18n.fallbacks = [:en]
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      attr_reader :klass
    end
  end
end
