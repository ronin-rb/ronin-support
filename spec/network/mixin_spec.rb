require 'spec_helper'
require 'ronin/support/network/mixin'

describe Ronin::Support::Network::Mixin do
  it "must include `Ronin::Support::Network::IP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::IP::Mixin)
  end

  it "must include `Ronin::Support::Network::DNS::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::DNS::Mixin)
  end

  it "must include `Ronin::Support::Network::TCP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::TCP::Mixin)
  end

  it "must include `Ronin::Support::Network::UDP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::UDP::Mixin)
  end

  it "must include `Ronin::Support::Network::SSL::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::SSL::Mixin)
  end

  it "must include `Ronin::Support::Network::UNIX::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::UNIX::Mixin)
  end

  it "must include `Ronin::Support::Network::HTTP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::HTTP::Mixin)
  end

  it "must include `Ronin::Support::Network::FTP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::FTP::Mixin)
  end

  it "must include `Ronin::Support::Network::SMTP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::SMTP::Mixin)
  end

  it "must include `Ronin::Support::Network::ESMTP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::ESMTP::Mixin)
  end

  it "must include `Ronin::Support::Network::POP3::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::POP3::Mixin)
  end

  it "must include `Ronin::Support::Network::IMAP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::IMAP::Mixin)
  end
end
