# frozen_string_literal: true

RSpec.describe Navio::Config do
  let(:config) { Navio::Config.new }

  before do
    allow(YAML).to receive(:load_file).and_return({})
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:open).and_yield(StringIO.new)
  end

  context "#get_url" do
    it "returns the url for a shortcut" do
      config.add_shortcut("google", "https://google.com")
      expect(config.get_url("google")).to eq("https://google.com")
    end

    it "returns nil for an unknown shortcut" do
      expect(config.get_url("unknown")).to be_nil
    end
  end

  context "#list_shortcuts" do
    it "returns a empty list of shortcuts if no shortcuts" do
      expect(config.list_shortcuts).to eq({})
    end

    it "returns a list of shortcuts" do
      config.add_shortcut("google", "https://google.com")
      expect(config.list_shortcuts).to eq({ "google" => "https://google.com" })
    end
  end

  context "#remove_shortcut" do
    it "removes a shortcut" do
      config.add_shortcut("google", "https://google.com")
      expect(config.remove_shortcut("google")).to eq(true)
      expect(config.get_url("google")).to be_nil
    end

    it "returns false if the shortcut does not exist" do
      expect(config.remove_shortcut("unknown")).to eq(false)
    end
  end
end
