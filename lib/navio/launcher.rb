# frozen_string_literal: true

require "launchy"

module Navio
  #= Open URLs in the default browser
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
