require 'spec_helper'
require 'ronin/support/network/mixin'

describe Ronin::Support::Network::Mixin do
  it "must include `Ronin::Support::Network::Mixins::IP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::IP)
  end

  it "must include `Ronin::Support::Network::Mixins::DNS`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::DNS)
  end

  it "must include `Ronin::Support::Network::Mixins::TCP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::TCP)
  end

  it "must include `Ronin::Support::Network::Mixins::UDP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::UDP)
  end

  it "must include `Ronin::Support::Network::Mixins::SSL`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::SSL)
  end

  it "must include `Ronin::Support::Network::Mixins::UNIX`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::UNIX)
  end

  it "must include `Ronin::Support::Network::HTTP`" do
    expect(subject).to include(Ronin::Support::Network::HTTP)
  end

  it "must include `Ronin::Support::Network::Mixins::FTP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::FTP)
  end

  it "must include `Ronin::Support::Network::Mixins::SMTP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::SMTP)
  end

  it "must include `Ronin::Support::Network::Mixins::ESMTP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::ESMTP)
  end

  it "must include `Ronin::Support::Network::Mixins::POP3`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::POP3)
  end

  it "must include `Ronin::Support::Network::Mixins::IMAP`" do
    expect(subject).to include(Ronin::Support::Network::Mixins::IMAP)
  end
end
