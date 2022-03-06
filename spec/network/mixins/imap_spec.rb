require 'spec_helper'
require 'ronin/support/network/mixins/imap'

describe Ronin::Support::Network::Mixins::IMAP do
  describe "helpers", :network do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    let(:host) { 'imap.gmail.com' }
    let(:port) { 993 }

    describe "#imap_connect" do
      it "should return a Net::IMAP object" do
        pending "need valid IMAP credentials"

        imap = subject.imap_connect(host,user,password, port: port, ssl: true)

        imap.should be_kind_of(Net::IMAP)

        imap.close
        imap.disconnect
      end

      pending "need valid IMAP credentials" do
        it "should connect to an IMAP service" do
          pending "need valid IMAP credentials"

          imap = subject.imap_connect(host,user,password, port: port, ssl: true)

          imap.close
          imap.disconnect
        end
      end

      context "when given a block" do
        pending "need valid IMAP credentials" do
          it "should yield the new Net::IMAP object" do
            pending "need valid IMAP credentials"

            imap = subject.imap_connect(host,user,password, port: port,
                                                            ssl: true) do |imap|
              imap.should be_kind_of(Net::IMAP)
            end

            imap.close
            imap.disconnect
          end
        end
      end
    end

    describe "#imap_session" do
      pending "need valid IMAP credentials" do
        it "should yield a new Net::IMAP object" do
          pending "need valid IMAP credentials"

          yielded_imap = nil

          subject.imap_session(host,user,password, port: port,
                                                   ssl: true) do |imap|
            yielded_imap = imap
          end

          yielded_imap.should be_kind_of(Net::IMAP)
        end
      end

      pending "need valid IMAP credentials" do
        it "should disconnect the IMAP session after yielding it" do
          pending "need valid IMAP credentials"

          imap          = nil
          was_connected = nil

          subject.imap_session(host,user,password, port: port,
                                                   ssl: true) do |yielded_imap|
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
