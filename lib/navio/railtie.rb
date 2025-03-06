# frozen_string_literal: true

require "rails"

module Navio
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../../tasks/navio.rake", __dir__)
    end
  end
end
