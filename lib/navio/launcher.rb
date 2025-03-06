require "launchy"

module Navio
  class Launcher
    def open_url(url)
      if url
        puts "Opening #{url}..."
        Launchy.open(url)
        true
      else
        puts "Error: No URL found for '#{url}'"
        false
      end
    end
  end
end
