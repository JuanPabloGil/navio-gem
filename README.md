# Navio

Navio is a simple CLI tool to quickly navigate to important project URLs. It allows you to define and access project-related URLs like design files, repositories, documentation, and more from your terminal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'navio'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install navio
```

## Usage

### Adding a Shortcut

To add a new shortcut, use the `add` command:

```bash
navio add <name> <url>
```

Example:

```bash
navio add repo https://github.com/username/project
navio add figma https://figma.com/file/project-design
```

### Removing a Shortcut

To remove an existing shortcut, use the `remove` command:

```bash
navio remove <name>
```

Example:

```bash
navio remove repo
```

### Listing Shortcuts

To list all defined shortcuts, use the `list` command:

```bash
navio list
```

### Opening a Shortcut

To open a URL associated with a shortcut, simply use the shortcut name:

```bash
navio <shortcut>
```

Example:

```bash
navio repo
```

### Help

To display the help message, use the `help` command:

```bash
navio help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
```bash
gem uninstall navio
gem build navio.gemspec
gem install ./navio-*.gem  
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/juanpablogil/project_navigator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/juanpablogil/project_navigator/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Navio project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/juanpablogil/project_navigator/blob/main/CODE_OF_CONDUCT.md).
