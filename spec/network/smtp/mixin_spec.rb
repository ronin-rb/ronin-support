require 'spec_helper'
require 'ronin/support/network/smtp/mixin'

describe Ronin::Support::Network::SMTP::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  let(:host) { 'smtp.gmail.com' }

  describe "#smtp_connect" do
    context "integration", :network do
      it "must return a Net::SMTP object" do
        pending "need valid SMTP credentials"

        smtp = subject.smtp_connect(host,user,password)

        smtp.should be_kind_of(Net::SMTP)
        smtp.finish
      end

      it "must connect to an SMTP service" do
        pending "need valid SMTP credentials"

        smtp = subject.smtp_connect(host,user,password)

        smtp.should be_started
        smtp.finish
      end

      context "when the hostname is a unicode hostname" do
        let(:host)  { "www.詹姆斯.com" }

        pending "need to find a SMTP server with a unicode domain" do
          it "must connect to the punycode version of the unicode hostname" do
            smtp = subject.smtp_connect(host,user,password)

            smtp.should be_started
            smtp.finish
          end
        end
      end

      context "when given a block" do
        it "must yield a new Net::SMTP object" do
          pending "need valid SMTP credentials"

          yielded_smtp = nil

          subject.smtp_connect(host,user,passowrd) do |smtp|
            yielded_smtp = smtp
          end

          yielded_smtp.should be_kind_of(Net::SMTP)
        end

        it "must finish the SMTP session after yielding it" do
          pending "need valid SMTP credentials"

          smtp        = nil
          was_started = nil

          subject.smtp_connect(host,user,password) do |yielded_smtp|
            smtp        = yielded_smtp
            was_started = smtp.started?
          end

          was_started.should == true
          smtp.should_not be_started
        end
      end
    end
  end
end
