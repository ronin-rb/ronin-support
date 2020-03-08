require 'spec_helper'
require 'ronin/network/ftp'

describe Network::FTP do
  describe "helpers", :network do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    let(:host) { 'ftp.kernel.org' }

    describe "#ftp_connect" do
      it "should return a Net::FTP object" do
        ftp = subject.ftp_connect(host)

        expect(ftp).to be_kind_of(Net::FTP)
        ftp.close
      end

      it "should connect to an FTP service" do
        ftp = subject.ftp_connect(host)

        expect(ftp).not_to be_closed
        ftp.close
      end

      describe ":passive" do
        it "should set passive mode by default" do
          ftp = subject.ftp_connect(host)

          expect(ftp.passive).to be_true
          ftp.close
        end

        it "should allow disabling passive mode" do
          ftp = subject.ftp_connect(host, :passive => false)

          expect(ftp.passive).to be_false
          ftp.close
        end
      end

      context "when given a block" do
        it "should yield the new Net::FTP object" do
          ftp = subject.ftp_connect(host) do |ftp|
            expect(ftp).to be_kind_of(Net::FTP)
          end

          ftp.close
        end
      end
    end

    describe "#ftp_session" do
      it "should yield a new Net::FTP object" do
        yielded_ftp = nil

        subject.ftp_session(host) do |ftp|
          yielded_ftp = ftp
        end

        expect(yielded_ftp).to be_kind_of(Net::FTP)
      end

      it "should close the FTP session after yielding it" do
        session  = nil
        was_open = nil

        subject.ftp_session(host) do |ftp|
          session   = ftp
          was_open  = !ftp.closed?
        end

        expect(was_open).to eq(true)
        expect(session).to be_closed
      end
    end
  end
end
