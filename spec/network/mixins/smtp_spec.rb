require 'spec_helper'
require 'ronin/network/mixins/smtp'

describe Network::Mixins::SMTP do
  its(:default_port) { should == 25 }

  describe "helpers", :network do
    let(:host) { 'smtp.gmail.com' }

    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    before { subject.host = host }

    describe "#smtp_connect" do
      it "should return a Net::SMTP object" do
        smtp = subject.smtp_connect

        smtp.should be_kind_of(Net::SMTP)
        smtp.finish
      end

      it "should connect to an SMTP service" do
        smtp = subject.smtp_connect

        smtp.should be_started
        smtp.finish
      end

      context "when given a block" do
        it "should yield the new Net::SMTP object" do
          smtp = subject.smtp_connect do |smtp|
            smtp.should be_kind_of(Net::SMTP)
          end

          smtp.finish
        end
      end
    end

    describe "#smtp_session" do
      it "should yield a new Net::SMTP object" do
        yielded_smtp = nil

        subject.smtp_session do |smtp|
          yielded_smtp = smtp
        end

        yielded_smtp.should be_kind_of(Net::SMTP)
      end

      it "should finish the SMTP session after yielding it" do
        smtp        = nil
        was_started = nil

        subject.smtp_session do |yielded_smtp|
          smtp        = yielded_smtp
          was_started = smtp.started?
        end

        was_started.should == true
        smtp.should_not be_started
      end
    end
  end
end
