require 'spec_helper'
require 'ronin/support/network/telnet/mixin'

describe Ronin::Support::Network::Telnet::Mixin do
  # NOTE: http://www.jumpjet.info/Offbeat-Internet/Public/TelNet/url.htm
  let(:host) { 'gcomm.com' }

  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#telnet_connect" do
    context "integration", :network do
      it "must return a Net::Telnet object" do
        telnet = subject.telnet_connect(host)

        expect(telnet).to be_kind_of(Net::Telnet)
        telnet.close
      end

      it "must connect to a telnet service on port 23" do
        telnet = subject.telnet_connect(host)

        telnet.close
      end

      context "when the hostname is a unicode hostname" do
        let(:host)  { "www.詹姆斯.com" }

        pending "need to find a Telnet server with a unicode domain" do
          it "must connect to the punycode version of the unicode domain" do
            telnet = subject.telnet_connect(host)

            expect(telnet).to be_kind_of(Net::Telnet)
            expect(telnet.sock).to_not be_closed

            telnet.close
          end
        end
      end

      context "when given a block" do
        it "must yield a new Net::Telnet object" do
          yielded_telnet = nil

          subject.telnet_connect(host) do |telnet|
            yielded_telnet = telnet
          end

          expect(yielded_telnet).to be_kind_of(Net::Telnet)
        end

        it "must close the Telnet session after yielding it" do
          session  = nil
          was_open = nil

          subject.telnet_connect(host) do |telnet|
            session   = telnet
            was_open  = !telnet.sock.closed?
          end

          expect(was_open).to be(true)
          expect(session.sock).to be_closed
        end
      end
    end
  end
end
