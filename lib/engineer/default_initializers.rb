# frozen_string_literal: true

module Engineer
  module DefaultInitializers
    def self.included(klass)
      db = Database::Initializers.new(klass)
      db.append_migrations
      db.share_db_paths

      Locale::Initializers.new(klass).setup_locales
    end
  end
end
