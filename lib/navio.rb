# frozen_string_literal: true

require_relative "navio/version"
require_relative "navio/config"
require_relative "navio/browser"
require_relative "navio/cli"

module Navio
  class Error < StandardError; end

  def self.run(args)
    CLI.new.run(args)
  end
end
