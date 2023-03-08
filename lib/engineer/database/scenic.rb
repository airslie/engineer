# frozen_string_literal: true

module Engineer
  module Database
    # The scenic gem supports loading SQL view definition files from a db/views folder but only
    # supports one folder (it looks in app.config.paths["db/views"] and takes the last one) which
    # works fine if you are using a rake task to copy all your views from various engines into the
    # host app. But this a bit issues prone and it is much nicer to add each engine's db/views
    # folder to app.config.paths (we do this in the Engineer::Database::Initializers class provided
    # the engine includes the appropriate file) and then here we override the Scenic
    # Definition#to_sql method and when a view definition file is requested, search all db/views
    # paths - which may search in several engines and host app itself - and hopefully find the file
    # we are looking for. In theory that file should be in the same engine/app that its
    # corresponding migration is in... though we can't verify that and its unlikely
    # We raise an error if we find two matching files i.e. a view definition file of the same name
    # in two gems.
    module ResolveScenicViewsAnywhere
      def to_sql
        view_definition_file = find_view_definition_among_all_possible_paths

        File.read(view_definition_file).tap do |content|
          if content.empty?
            raise "Define view query in #{path} before migrating."
          end
        end
      end

      def find_view_definition_among_all_possible_paths
        found_files = all_full_paths.select { |path| File.exist?(path) }
        if found_files.length > 1
          raise "More than one view definition matches the name #{filename}\n #{found_files}"
        end

        found_files.first
      end

      def all_full_paths
        app = Rails.application
        return super unless defined?(app) && app.present?

        app.config.paths["db/views"].map { |path| File.join(path, filename) }
      end
    end

    if defined?(Scenic)
      Scenic::Definition.prepend ResolveScenicViewsAnywhere
    end
  end
end
