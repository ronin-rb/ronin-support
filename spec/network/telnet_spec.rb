require 'spec_helper'
require 'ronin/support/network/telnet'

describe Network::Telnet do
  let(:host) { 'towel.blinkenlights.nl' }

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
