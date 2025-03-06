require "rbconfig"

module Navio
  class Browser
    def self.open(url)
      platform = RbConfig::CONFIG["host_os"]

      command = case platform
                when /mswin|mingw|cygwin/
                  "start \"\" \"#{url}\""
                when /darwin/
                  "open \"#{url}\""
                when /linux|bsd/
                  # Try a series of browsers in this order
                  browsers = %w[xdg-open sensible-browser firefox google-chrome chromium-browser]
                  browser = browsers.find { |b| system("which #{b} > /dev/null 2>&1") }
                  browser ? "#{browser} \"#{url}\"" : nil
                end

      if command
        system(command)
        true
      else
        puts "Could not determine how to open URLs on your platform (#{platform})."
        puts "URL: #{url}"
        false
      end
    end
  end
end
