require 'spec_helper'
require 'ronin/support/network/imap/mixin'

describe Ronin::Support::Network::IMAP::Mixin do
  describe "helpers", :network do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    let(:host) { 'imap.gmail.com' }
    let(:port) { 993 }

    describe "#imap_connect" do
      it "must return a Net::IMAP object" do
        pending "need valid IMAP credentials"

        imap = subject.imap_connect(host,user,password, port: port, ssl: true)

        imap.should be_kind_of(Net::IMAP)

        imap.close
        imap.disconnect
      end

      context "when the hostname is a unicode hostname" do
        let(:host)  { "www.詹姆斯.com" }

        pending "need to find a IMAP server with a unicode domain" do
          it "must connect to the punycode version of the unicode domain" do
            imap = subject.imap_connect(host,user,password, port: port, ssl: true)

            imap.should be_kind_of(Net::IMAP)

            imap.close
            imap.disconnect
          end
        end
      end

      pending "need valid IMAP credentials" do
        it "must connect to an IMAP service" do
          pending "need valid IMAP credentials"

          imap = subject.imap_connect(host,user,password, port: port, ssl: true)

          imap.close
          imap.disconnect
        end
      end

      context "when given a block" do
        pending "need valid IMAP credentials" do
          it "must yield a new Net::IMAP object" do
            pending "need valid IMAP credentials"

            yielded_imap = nil

            subject.imap_connect(host,user,password, port: port, ssl: true) do |imap|
              yielded_imap = imap
            end

            yielded_imap.should be_kind_of(Net::IMAP)
          end
        end

        pending "need valid IMAP credentials" do
          it "must disconnect the IMAP session after yielding it" do
            pending "need valid IMAP credentials"

            imap          = nil
            was_connected = nil

            subject.imap_connect(host,user,password, port: port, ssl: true) do |yielded_imap|
              imap          = yielded_imap
              was_connected = !imap.disconnected?
            end

            was_connected.should == true
            imap.should be_disconnected
          end
        end
      end
    end
  end
end
