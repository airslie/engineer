# frozen_string_literal: true

module Engineer
  module Database
    #
    # Add db/migrate, db/views, db/triggers and db/functions folders to app.config.paths so they
    # can be resolved during migration
    # Be sure sure to append to any existing entries in #paths, because other engines, and
    # the app itself, will add their paths too.
    # This step is especially important for the Scenic gem; sql view definitions in db/views
    # are referenced by filename from migrations, and we need to be able to locate those files.
    # The Scenic issue is a bit more too it see scenic.rb for more info.
    # Note that a common but way more kludgy approach to this problem is to copy the migrations
    # views etc from each gen into the host app with a rake task. This is a slicker a less
    # error-proone solution.
    #
    class AppendEnginePaths
      attr_reader :app, :engine_config

      def initialize(app:, engine_config:)
        @app = app
        @engine_config = engine_config
      end

      def call
        append_migration_paths
        append_other_paths
      end

      # db/migrate paths are handled rather differently.
      # Prevent duplicate migrations if we are db:migrating at the engine level (eg when
      # running tests) rather than the host app.
      def append_migration_paths
        if running_in_dummy_app? || running_outside_of_engine?
          add_engine_db_path_to_app("migrate")
        end
      end

      def append_other_paths
        %w(views functions triggers).each do |sub_folder|
          add_engine_db_path_to_app(sub_folder)
        end
      end

      def add_engine_db_path_to_app(sub_folder)
        key = "db/#{sub_folder}"
        path_to_db_things_in_engine = Rails.root.join(engine_config.root, "db", sub_folder)
        app_config = app.config
        app_config.paths[key] ||= []
        app_config.paths[key] << path_to_db_things_in_engine
      end

      def running_in_dummy_app?
        Dir.pwd.ends_with?("dummy")
      end

      def running_outside_of_engine?
        app.root.to_s.match(engine_config.root.to_s + File::SEPARATOR).nil?
      end
    end
  end
end
