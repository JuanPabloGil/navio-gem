# frozen_string_literal: true

require "yaml"

module Navio
  # This class handles the configuration for the Navio project navigator.
  # It allows for loading, saving, and managing URL shortcuts stored in a YAML configuration file.
  #
  # The configuration file is named `.project_navigator.yml` and is searched for in the current directory,
  # its parent directories, and the user's home directory.
  #
  # Example usage:
  #   config = Navio::Config.new
  #   config.add_shortcut("github", "https://github.com")
  #   url = config.get_url("github")
  #   config.remove_shortcut("github")
  #
  # Methods:
  # - initialize: Loads the configuration from the YAML file.
  # - get_url(shortcut): Retrieves the URL for a given shortcut.
  # - list_shortcuts: Lists all the shortcuts.
  # - add_shortcut(name, url): Adds a new shortcut with the given name and URL.
  # - remove_shortcut(name): Removes the shortcut with the given name.
  #
  # Private Methods:
  # - config_path: Determines the path to the configuration file.
  # - find_config_in_path(start_path): Searches for the configuration file starting from a given path.
  # - load_config: Loads the configuration from the YAML file.
  # - save_config: Saves the current configuration to the YAML file.
  class Config
    CONFIG_FILE = ".project_navigator.yml"

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

    private

    def config_path
      path = find_config_in_path(Dir.pwd)
      path ||= File.join(Dir.home, CONFIG_FILE)
      path
    end

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

    def save_config
      File.open(config_path, "w") do |file|
        file.write(YAML.dump(@config))
      end
    end
  end
end
