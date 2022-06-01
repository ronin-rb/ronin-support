require 'spec_helper'
require 'ronin/support/home'

describe Ronin::Support::Home do
  describe "DIR" do
    it "must equal Gem.user_home" do
      expect(subject::DIR).to eq(Gem.user_home)
    end
  end

  describe "CACHE_DIR" do
    it "must equal ~/.cache" do
      expect(subject::CACHE_DIR).to eq(
        File.join(Gem.user_home,'.cache')
      )
    end
  end

  describe ".cache_dir" do
    let(:name) { 'foo' }

    it "must join ~/.cache with the given directory name" do
      expect(subject.cache_dir(name)).to eq(
        File.join(Gem.user_home,'.cache',name)
      )
    end
  end

  describe "CONFIG_DIR" do
    it "must equal ~/.config" do
      expect(subject::CONFIG_DIR).to eq(
        File.join(Gem.user_home,'.config')
      )
    end
  end

  describe ".config_dir" do
    let(:name) { 'foo' }

    it "must join ~/.config with the given directory name" do
      expect(subject.config_dir(name)).to eq(
        File.join(Gem.user_home,'.config',name)
      )
    end
  end

  describe "LOCAL_SHARE" do
    it "must equal ~/.local/share" do
      expect(subject::LOCAL_SHARE_DIR).to eq(
        File.join(Gem.user_home,'.local','share')
      )
    end
  end

  describe ".local_share_dir" do
    let(:name) { 'foo' }

    it "must join ~/.local/share with the given directory name" do
      expect(subject.local_share_dir(name)).to eq(
        File.join(Gem.user_home,'.local','share',name)
      )
    end
  end
end
