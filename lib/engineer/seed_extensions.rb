# frozen_string_literal: true

module Engineer
  module SeedExtensions
    def load_demo_seed
      require root.join("demo_data/seeds")
    end
  end
end

Rails::Engine.prepend(Engineer::SeedExtensions)
