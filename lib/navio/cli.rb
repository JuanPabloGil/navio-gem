# frozen_string_literal: true

require_relative "config"
require_relative "launcher"

require "byebug"
module Navio
  # CLI class provides command-line interface for managing project URL shortcuts.
  class CLI
    # Command mapping with command names as keys and method names as values
    COMMANDS = {
      "add" => :add_shortcut,
      "set" => :add_shortcut,
      "remove" => :remove_shortcut,
      "rm" => :remove_shortcut,
      "delete" => :remove_shortcut,
      "list" => :list_shortcuts,
      "ls" => :list_shortcuts,
      "help" => :show_help
    }.freeze

    def initialize
      @config = Config.new
      @launcher = Launcher.new
    end

    def run(args)
      return show_help if args.empty?

      command = args.shift

      if COMMANDS.key?(command)
        send(COMMANDS[command], args)
      else
        open_url(command) || show_help
      end
    end

    private

    def open_url(shortcut)
      url = @config.get_url(shortcut)
      if url
        @launcher.open_url(url)
        true
      else
        puts "Error: No URL found for '#{shortcut}'"
        false
      end
    end

    def add_shortcut(args)
      if args.size < 2
        puts "Error: Missing arguments. Usage: navio add <shortcut> <url>"
        return
      end

      name = args[0]
      url = args[1]

      url = "https://#{url}" unless url.start_with?("http://", "https://")

      @config.add_shortcut(name, url)
      puts "Added shortcut '#{name}' -> #{url}"
    end

    def remove_shortcut(args)
      if args.empty?
        puts "Error: Missing shortcut name. Usage: navio remove <shortcut>"
        return
      end

      name = args[0]

      if @config.remove_shortcut(name)
        puts "Removed shortcut '#{name}'"
      else
        puts "Error: Shortcut '#{name}' not found"
      end
    end

    def list_shortcuts(_args = [])
      shortcuts = @config.list_shortcuts

      if shortcuts.empty?
        puts "No shortcuts defined. Add one with 'navio add <shortcut> <url>'"
        return
      end

      puts "Defined shortcuts:"
      shortcuts.each do |name, url|
        puts "  #{name} -> #{url}"
      end
    end

    def show_help(_args = [])
      puts <<~HELP
        Navio - Quick access to project URLs

        Usage:
          navio <shortcut>           Open the URL for the given shortcut
          navio add <name> <url>     Add a new shortcut
          navio remove <name>        Remove a shortcut
          navio list                 Show all defined shortcuts
          navio help                 Show this help message

        Examples:
          navio add repo https://github.com/username/project
          navio add figma https://figma.com/file/project-design
          navio repo                 # Opens the repository URL
      HELP
    end
  end
end
