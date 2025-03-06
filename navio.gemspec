# frozen_string_literal: true

require_relative "lib/navio/version"

Gem::Specification.new do |spec|
  spec.name = "navio"
  spec.version = Navio::VERSION
  spec.authors = ["Juan Pablo Gil"]
  spec.email = ["juanpablo.gil@icloud.com"]

  spec.summary = "A simple CLI tool to quickly navigate to important project URLs"
  spec.description = "Project Navigator provides a convenient way to define and access important project-related " \
                     "URLs like design files, repositories, documentation, and more from your terminal."
  spec.homepage = "https://github.com/JuanPabloGil/navio-gem/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/JuanPabloGil/navio-gem/"
  spec.metadata["changelog_uri"] = "https://github.com/juanpablogil/navio-gem/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables = ["navio"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "launchy", "~> 3.1.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
