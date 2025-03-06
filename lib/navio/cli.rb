# frozen_string_literal: true

require "config"
require "browser"

module Navio
  class CLI
    def initialize
      @config = Config.new
    end

    def run(args)
      if args.empty?
        show_help
        return
      end

      command = args.shift

      case command
      when "add", "set"
        add_shortcut(args)
      when "remove", "rm", "delete"
        remove_shortcut(args)
      when "list", "ls"
        list_shortcuts
      when "help"
        show_help
      else
        # Assume it's a shortcut name
        open_url(command) || show_help
      end
    end

    private

    def open_url(shortcut)
      url = @config.get_url(shortcut)

      if url
        puts "Opening #{url}..."
        Browser.open(url)
        true
      else
        puts "Error: No URL found for '#{shortcut}'"
        false
      end
    end

    def add_shortcut(args)
      if args.size < 2
        puts "Error: Missing arguments. Usage: nav add <shortcut> <url>"
        return
      end

      name = args[0]
      url = args[1]

      # Add protocol if missing
      url = "https://#{url}" unless url.start_with?("http://", "https://")

      @config.add_shortcut(name, url)
      puts "Added shortcut '#{name}' -> #{url}"
    end

    def remove_shortcut(args)
      if args.empty?
        puts "Error: Missing shortcut name. Usage: nav remove <shortcut>"
        return
      end

      name = args[0]

      if @config.remove_shortcut(name)
        puts "Removed shortcut '#{name}'"
      else
        puts "Error: Shortcut '#{name}' not found"
      end
    end

    def list_shortcuts
      shortcuts = @config.list_shortcuts

      if shortcuts.empty?
        puts "No shortcuts defined. Add one with 'nav add <shortcut> <url>'"
        return
      end

      puts "Defined shortcuts:"
      shortcuts.each do |name, url|
        puts "  #{name} -> #{url}"
      end
    end

    def show_help
      puts <<~HELP
        Project Navigator - Quick access to project URLs

        Usage:
          nav <shortcut>           Open the URL for the given shortcut
          nav add <name> <url>     Add a new shortcut
          nav remove <name>        Remove a shortcut
          nav list                 Show all defined shortcuts
          nav help                 Show this help message

        Examples:
          nav add repo https://github.com/username/project
          nav add figma https://figma.com/file/project-design
          nav repo                 # Opens the repository URL
      HELP
    end
  end
end
