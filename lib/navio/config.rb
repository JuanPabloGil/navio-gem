# frozen_string_literal: true

require "yaml"

module Navio
  # This class handles the configuration for the Navio project navigator.
  # It allows for loading, saving, and managing URL shortcuts stored in a YAML configuration file.
  class Config
    CONFIG_FILE = ".navio.yml"

    def initialize
      @config = load_config
    end

    def get_url(shortcut)
      @config["shortcuts"] && @config["shortcuts"][shortcut]
    end

    def list_shortcuts
      @config["shortcuts"] || {}
    end

    def add_shortcut(name, url)
      @config["shortcuts"] ||= {}
      @config["shortcuts"][name] = url
      save_config
    end

    def remove_shortcut(name)
      return false unless @config["shortcuts"] && @config["shortcuts"][name]

      @config["shortcuts"].delete(name)
      save_config
      true
    end

    def config_path
      path = find_config_in_path(Dir.pwd)
      path ||= File.join(Dir.home, CONFIG_FILE)
      path
    end

    def save_config
      File.open(config_path, "w") do |file|
        file.write(YAML.dump(@config))
      end
    end

    private

    def find_config_in_path(start_path)
      path = start_path
      while path != "/"
        config_file = File.join(path, CONFIG_FILE)
        return config_file if File.exist?(config_file)

        path = File.dirname(path)
      end
      nil
    end

    def load_config
      if File.exist?(config_path)
        YAML.load_file(config_path) || {}
      else
        { "shortcuts" => {} }
      end
    end
  end
end
