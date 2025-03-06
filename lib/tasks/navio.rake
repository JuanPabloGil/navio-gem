# frozen_string_literal: true

namespace :navio do
  desc "Install Navio configuration file"
  task :install do
    require_relative "../navio/config"

    config = Navio::Config.new
    config_path = config.send(:config_path)

    if File.exist?(config_path)
      puts "Configuration file already exists at #{config_path}"
    else
      config.send(:save_config)
      puts "Created new configuration file at #{config_path}"
    end
  end
end
