# frozen_string_literal: true

require_relative "navio/version"
require_relative "navio/config"
require_relative "navio/launcher"
require_relative "navio/cli"
require_relative "navio/railtie"

# Navio is a module that provides functionality for the Navio application.
module Navio
  class Error < StandardError; end

  def self.run(args)
    CLI.new.run(args)
  end

  def self.version
    Navio::VERSION
  end
end
