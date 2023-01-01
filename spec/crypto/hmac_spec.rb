require 'spec_helper'
require 'ronin/support/crypto/hmac'

describe Ronin::Support::Crypto::HMAC do
  let(:key)    { "secret" }
  let(:digest) { OpenSSL::Digest::SHA1.new }
  let(:data)   { "hello world" }

  subject { described_class.new(key,digest) }

  before { subject << data }

  describe "#inspect" do
    it "must return a String containing the class name and hexdigest" do
      expect(subject.inspect).to eq(
        "#<#{described_class}: #{subject.hexdigest}>"
      )
    end
  end
end
