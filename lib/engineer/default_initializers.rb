# frozen_string_literal: true

module Engineer
  module DefaultInitializers
    def self.included(klass)
      Database::Initializers.new(klass).add
      Locale::Initializers.new(klass).add
    end
  end
end
