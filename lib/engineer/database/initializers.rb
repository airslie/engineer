# frozen_string_literal: true

module Engineer
  module Database
    class Initializers
      def initialize(klass)
        @klass = klass
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def append_migrations
        klass.initializer :"append_migrations_in_#{klass.name.underscore.tr("/", "_")}" do |app|
          # Prevent duplicate migrations if we are db:migrating at the engine level (eg when
          # running tests) rather than the host app
          running_in_dummy_app = Dir.pwd.ends_with?("dummy")
          running_outside_of_engine = app.root.to_s.match(root.to_s + File::SEPARATOR).nil?

          if running_in_dummy_app || running_outside_of_engine
            engine_migration_paths = config.paths["db/migrate"]
            app_migration_paths =  app.config.paths["db/migrate"]

            engine_migration_paths.expanded.each do |expanded_path|
              app_migration_paths << expanded_path
            end
          end
        end
      end

      # Add db/views, db/triggers and db/functions folders to the app.config.paths.
      # Be sure sure to append to any existing entries in #paths, becuase other engines, and
      # the app itself, will add their paths.
      # Tgus step is especially important for the Scenic gem; sql view definitions in db/views
      # are referenced by filename from migrations, and we need to be able to locate those files.
      # The Scenic issues has another component the Scenic helper class in the gem for more info.
      # Note that a common but way more kludgy approach to this problem is to copy the migrations
      # views etc from each gen into the host app with a rake task. Yuketty-yuk.
      def share_db_paths
        klass.initializer :"share_db_paths_in_#{klass.name.underscore.tr("/", "_")}" do |app|
          %w(views functions triggers).each do |db_thing|
            path_to_db_things_in_engine = Rails.root.join(config.root, "db", db_thing)
            app.config.paths["db/#{db_thing}"] ||= []
            app.config.paths["db/#{db_thing}"] << path_to_db_things_in_engine
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      private

      attr_reader :klass
    end
  end
end
