require 'spec_helper'
require 'ronin/support/network/mixins/smtp'

describe Ronin::Support::Network::Mixins::SMTP do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  let(:host) { 'smtp.gmail.com' }

  describe "#smtp_connect" do
    context "integration", :network do
      it "should return a Net::SMTP object" do
        pending "need valid SMTP credentials"

        smtp = subject.smtp_connect(host,user,password)

        smtp.should be_kind_of(Net::SMTP)
        smtp.finish
      end

      it "should connect to an SMTP service" do
        pending "need valid SMTP credentials"

        smtp = subject.smtp_connect(host,user,password)

        smtp.should be_started
        smtp.finish
      end

      context "when given a block" do
        it "should yield the new Net::SMTP object" do
          pending "need valid SMTP credentials"

          smtp = subject.smtp_connect(host,user,password) do |smtp|
            smtp.should be_kind_of(Net::SMTP)
          end

          smtp.finish
        end
      end

      context "when :ssl is given" do
        let(:port) { 587 }

        it "should initiate a SSL connection" do
          pending "need valid SMTP credentials"

          smtp = subject.smtp_connect(host,user,password, port: port, ssl: true)

          smtp.should be_started
          smtp.finish
        end
      end
    end
  end

  describe "#smtp_session" do
    context "integration", :network do
      it "should yield a new Net::SMTP object" do
        pending "need valid SMTP credentials"

        yielded_smtp = nil

        subject.smtp_session(host,user,passowrd) do |smtp|
          yielded_smtp = smtp
        end

        yielded_smtp.should be_kind_of(Net::SMTP)
      end

      it "should finish the SMTP session after yielding it" do
        pending "need valid SMTP credentials"

        smtp        = nil
        was_started = nil

        subject.smtp_session(host,user,password) do |yielded_smtp|
          smtp        = yielded_smtp
          was_started = smtp.started?
        end

        was_started.should == true
        smtp.should_not be_started
      end
    end
  end
end
