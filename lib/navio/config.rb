# frozen_string_literal: true

require "yaml"

module Navio
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
      # Look for config in current directory, then parents, then home
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
