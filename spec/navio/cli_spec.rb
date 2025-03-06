# frozen_string_literal: true

require "spec_helper"

RSpec.describe Navio::CLI do
  let(:config) { instance_double(Navio::Config) }
  let(:launcher) { instance_double(Navio::Launcher) }
  let(:cli) { Navio::CLI.new }

  before do
    # Replace the actual Config and Launcher with our test doubles
    allow(Navio::Config).to receive(:new).and_return(config)
    allow(Navio::Launcher).to receive(:new).and_return(launcher)

    # Suppress output during tests
    allow($stdout).to receive(:puts)
  end

  describe "#run" do
    context "with no arguments" do
      it "shows help" do
        expect(cli).to receive(:show_help)
        cli.run([])
      end
    end

    context "with a recognized command" do
      it "runs the add_shortcut command" do
        expect(cli).to receive(:add_shortcut).with(["test", "https://example.com"])
        cli.run(["add", "test", "https://example.com"])
      end

      it "runs the remove_shortcut command" do
        expect(cli).to receive(:remove_shortcut).with(["test"])
        cli.run(%w[remove test])
      end

      it "runs the list_shortcuts command" do
        expect(cli).to receive(:list_shortcuts).with([])
        cli.run(["list"])
      end

      it "runs the help command" do
        expect(cli).to receive(:show_help).with([])
        cli.run(["help"])
      end

      it "recognizes aliases for commands" do
        expect(cli).to receive(:add_shortcut)
        cli.run(["set", "test", "https://example.com"])

        expect(cli).to receive(:remove_shortcut)
        cli.run(%w[rm test])

        expect(cli).to receive(:list_shortcuts)
        cli.run(["ls"])
      end
    end

    context "with an unrecognized command" do
      context "when it matches a shortcut" do
        it "opens the URL" do
          expect(config).to receive(:get_url).with("github").and_return("https://github.com")
          expect(launcher).to receive(:open_url).with("https://github.com")

          cli.run(["github"])
        end
      end

      context "when it doesn't match a shortcut" do
        it "shows help" do
          expect(config).to receive(:get_url).with("nonexistent").and_return(nil)
          expect(cli).to receive(:show_help)

          cli.run(["nonexistent"])
        end
      end
    end
  end

  describe "#add_shortcut" do
    context "with valid arguments" do
      it "adds a shortcut" do
        expect(config).to receive(:add_shortcut).with("test", "https://example.com")
        cli.send(:add_shortcut, ["test", "https://example.com"])
      end

      it "adds https:// prefix if missing" do
        expect(config).to receive(:add_shortcut).with("test", "https://example.com")
        cli.send(:add_shortcut, ["test", "example.com"])
      end

      it "doesn't modify URL with http:// prefix" do
        expect(config).to receive(:add_shortcut).with("test", "http://example.com")
        cli.send(:add_shortcut, ["test", "http://example.com"])
      end
    end

    context "with invalid arguments" do
      it "shows an error if missing arguments" do
        expect(config).not_to receive(:add_shortcut)
        expect { cli.send(:add_shortcut, ["test"]) }.to output(/Error: Missing arguments/).to_stdout
      end
    end
  end

  describe "#remove_shortcut" do
    context "with a valid shortcut" do
      it "removes the shortcut" do
        expect(config).to receive(:remove_shortcut).with("test").and_return(true)
        expect { cli.send(:remove_shortcut, ["test"]) }.to output(/Removed shortcut/).to_stdout
      end
    end

    context "with an invalid shortcut" do
      it "shows an error if shortcut doesn't exist" do
        expect(config).to receive(:remove_shortcut).with("test").and_return(false)
        expect { cli.send(:remove_shortcut, ["test"]) }.to output(/Error: Shortcut.*not found/).to_stdout
      end

      it "shows an error if missing arguments" do
        expect(config).not_to receive(:remove_shortcut)
        expect { cli.send(:remove_shortcut, []) }.to output(/Error: Missing shortcut name/).to_stdout
      end
    end
  end

  describe "#list_shortcuts" do
    context "with shortcuts defined" do
      it "lists all shortcuts" do
        expect(config).to receive(:list_shortcuts).and_return({
                                                                "github" => "https://github.com",
                                                                "google" => "https://google.com"
                                                              })

        expect { cli.send(:list_shortcuts) }.to output(%r{github -> https://github.com}).to_stdout
      end
    end

    context "with no shortcuts defined" do
      it "shows a message" do
        expect(config).to receive(:list_shortcuts).and_return({})
        expect { cli.send(:list_shortcuts) }.to output(/No shortcuts defined/).to_stdout
      end
    end
  end

  describe "#open_url" do
    context "with a valid shortcut" do
      it "opens the URL" do
        expect(config).to receive(:get_url).with("github").and_return("https://github.com")
        expect(launcher).to receive(:open_url).with("https://github.com")

        expect(cli.send(:open_url, "github")).to be true
      end
    end

    context "with an invalid shortcut" do
      it "shows an error message" do
        expect { cli.open_url(nonexistent) }.to output(/Error: No URL found for/).to_stdout
        expect(cli.send(:open_url, "nonexistent")).to be false
      end
    end
  end

  describe "#show_help" do
    it "displays help information" do
      expect { cli.send(:show_help) }.to output(/Navio - Quick access to project URLs/).to_stdout
    end
  end
end
