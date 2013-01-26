require 'spec_helper'
require 'ronin/network/mixins/ftp'

describe Network::Mixins::FTP do
  describe "helpers", :network do
    let(:host) { 'ftp.kernel.org' }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    before { subject.host = host }

    describe "#ftp_connect" do
      it "should return a Net::FTP object" do
        ftp = subject.ftp_connect

        ftp.should be_kind_of(Net::FTP)
        ftp.close
      end

      it "should connect to an FTP service" do
        ftp = subject.ftp_connect

        ftp.should_not be_closed
        ftp.close
      end

      describe ":passive" do
        it "should set passive mode by default" do
          ftp = subject.ftp_connect

          ftp.passive.should be_true
          ftp.close
        end

        it "should allow disabling passive mode" do
          ftp = subject.ftp_connect(nil, passive: false)

          ftp.passive.should be_false
          ftp.close
        end
      end

      context "when given a block" do
        it "should yield the new Net::FTP object" do
          ftp = subject.ftp_connect do |ftp|
            ftp.should be_kind_of(Net::FTP)
          end

          ftp.close
        end
      end
    end

    describe "#ftp_session" do
      it "should yield a new Net::FTP object" do
        yielded_ftp = nil

        subject.ftp_session do |ftp|
          yielded_ftp = ftp
        end

        yielded_ftp.should be_kind_of(Net::FTP)
      end

      it "should close the FTP session after yielding it" do
        session  = nil
        was_open = nil

        subject.ftp_session do |ftp|
          session   = ftp
          was_open  = !ftp.closed?
        end

        was_open.should == true
        session.should be_closed
      end
    end
  end
end
