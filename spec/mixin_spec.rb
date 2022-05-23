require 'spec_helper'
require 'ronin/support/mixin'

describe Ronin::Support::Mixin do
  subject do
    Class.new { include Ronin::Support::Mixin }
  end

  it "must include `Ronin::Support::Compression::Mixin`" do
    expect(subject).to include(Ronin::Support::Compression::Mixin)
  end

  it "must include `Ronin::Support::Crypto::Mixin`" do
    expect(subject).to include(Ronin::Support::Crypto::Mixin)
  end

  it "must include `Ronin::Support::Network::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::Mixin)
  end

  it "must include `Ronin::Support::CLI::Printing`" do
    expect(subject).to include(Ronin::Support::CLI::Printing)
  end
end
