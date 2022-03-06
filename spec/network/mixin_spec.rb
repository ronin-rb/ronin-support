require 'spec_helper'
require 'ronin/support/network/mixin'

describe Ronin::Support::Network::Mixin do
  it "must include `Ronin::Support::Network::IP`" do
    expect(subject).to include(Ronin::Support::Network::IP)
  end

  it "must include `Ronin::Support::Network::Mixins::DNS`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::DNS)
  end

  it "must include `Ronin::Support::Network::Mixins::TCP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::TCP)
  end

  it "must include `Ronin::Support::Network::UDP`" do
    expect(subject).to include(Ronin::Support::Network::UDP)
  end

  it "must include `Ronin::Support::Network::SSL`" do
    expect(subject).to include(Ronin::Support::Network::SSL)
  end

  it "must include `Ronin::Support::Network::UNIX`" do
    expect(subject).to include(Ronin::Support::Network::UNIX)
  end

  it "must include `Ronin::Support::Network::HTTP`" do
    expect(subject).to include(Ronin::Support::Network::HTTP)
  end

  it "must include `Ronin::Support::Network::FTP`" do
    expect(subject).to include(Ronin::Support::Network::FTP)
  end

  it "must include `Ronin::Support::Network::SMTP`" do
    expect(subject).to include(Ronin::Support::Network::SMTP)
  end

  it "must include `Ronin::Support::Network::ESMTP`" do
    expect(subject).to include(Ronin::Support::Network::ESMTP)
  end

  it "must include `Ronin::Support::Network::POP3`" do
    expect(subject).to include(Ronin::Support::Network::POP3)
  end

  it "must include `Ronin::Support::Network::IMAP`" do
    expect(subject).to include(Ronin::Support::Network::IMAP)
  end
end
