# frozen_string_literal: true

require "launchy"

module Navio
  #= Open URLs in the default browser
  class Launcher
    def open_url(url)
      if url
        Launchy.open(url)
        true
      else
        false
      end
    end
  end
end
