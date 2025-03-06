require "launchy"

module Navio
  class Launcher
    def initialize(config)
      @config = config
    end

    def open_url(shortcut)
      url = @config.get_url(shortcut)

      if url
        puts "Opening #{url}..."
        Launchy.open(url)
        true
      else
        puts "Error: No URL found for '#{shortcut}'"
        false
      end
    end
  end
end
