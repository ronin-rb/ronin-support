require 'spec_helper'
require 'ronin/network/proxy'

describe Network::Proxy do
  let(:port)  { 1337              }
  let(:host)  { '127.0.0.1'       }
  let(:server_host) { 'www.example.com' }
  let(:server_port) { 80                }

  let(:proxy) do
    described_class.new(
      :port   => port,
      :host   => host,
      :server => [server_host, server_port]
    )
  end

  subject { proxy }

  describe "#initialize" do
    it "should default host to '0.0.0.0'" do
      proxy = described_class.new(
        :port   => port,
        :server => [server_host, server_port]
      )

      proxy.port.should == port
      proxy.host.should == '0.0.0.0'
    end

    it "should allow setting both the host and port" do
      proxy = described_class.new(
        :port   => port,
        :host   => host,
        :server => [server_host, server_port]
      )

      proxy.port.should == port
      proxy.host.should == host
    end

    it "should set the server_host and server_port" do
      proxy = described_class.new(
        :port   => port,
        :host   => host,
        :server => [server_host, server_port]
      )

      proxy.server_host.should == server_host
      proxy.server_port.should == server_port
    end
  end

  describe "#on_data" do
    it "should call on_client_data" do
      subject.should_receive(:on_client_data)

      subject.on_data { |client,server,data| }
    end

    it "should call on_server_data" do
      subject.should_receive(:on_server_data)

      subject.on_data { |client,server,data| }
    end
  end

  describe "actions" do
    describe "#drop!" do
      it "should throw the :drop action" do
        lambda {
          subject.drop!
        }.should throw_symbol(:action, :drop)
      end
    end

    describe "#close!" do
      it "should throw the :close action" do
        lambda {
          subject.close!
        }.should throw_symbol(:action, :close)
      end
    end

    describe "#reset!" do
      it "should throw the :reset action" do
        lambda {
          subject.reset!
        }.should throw_symbol(:action, :reset)
      end
    end

    describe "#stop!" do
      it "should throw the :stop action" do
        lambda {
          subject.stop!
        }.should throw_symbol(:action, :stop)
      end
    end
  end

  describe "#to_s" do
    subject { proxy.to_s }

    it "should include the proxy host and port" do
      subject.should include("#{host}:#{port}")
    end

    it "should include the server host and port" do
      subject.should include("#{server_host}:#{server_port}")
    end
  end

  describe "#inspect" do
    subject { proxy.inspect }

    it "should include the output of #to_s" do
      subject.should include(proxy.to_s)
    end
  end
end
