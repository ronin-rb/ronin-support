require 'spec_helper'
require 'ronin/support/network/pop3'

describe Network::POP3 do
  describe "helpers", :network do
    subject do
      obj = Object.new
      obj.extend described_class
      obj
    end

    let(:host) { 'pop.gmail.com' }
    let(:port) { 995 }

    describe "#pop3_connect" do
      pending "need valid POP3 credentials" do
        it "should return a Net::POP3 object" do
          pop3 = subject.pop3_connect(host, port: port, ssl: true)

          pop3.should be_kind_of(Net::POP3)
          pop3.finish
        end
      end

      pending "need valid POP3 credentials" do
        it "should connect to an POP3 service" do
          pop3 = subject.pop3_connect(host, port: port, ssl: true)

          pop3.should be_started
          pop3.finish
        end
      end

      context "when given a block" do
        pending "need valid POP3 credentials" do
          it "should yield the new Net::POP3 object" do
            pop3 = subject.pop3_connect(host, port: port, ssl: true) do |pop3|
              pop3.should be_kind_of(Net::POP3)
            end

            pop3.finish
          end
        end
      end

      describe "#pop3_session" do
        pending "need valid POP3 credentials" do
          it "should yield a new Net::POP3 object" do
            yielded_pop3 = nil

            subject.pop3_session(host, port: port, ssl: true) do |pop3|
              yielded_pop3 = pop3
            end

            yielded_pop3.should be_kind_of(Net::POP3)
          end
        end

        pending "need valid POP3 credentials" do
          it "should finish the POP3 session after yielding it" do
            pop3        = nil
            was_started = nil

            subject.pop3_session(host, port: port, ssl: true) do |yielded_pop3|
              pop3        = yielded_pop3
              was_started = pop3.started?
            end

            was_started.should == true
            pop3.should_not be_started
          end
        end
      end
    end
  end
end
