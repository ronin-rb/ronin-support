require 'spec_helper'
require 'ronin/support/network/proxy'

describe Network::Proxy do
  let(:port)  { 1337              }
  let(:host)  { '127.0.0.1'       }
  let(:server_host) { 'www.example.com' }
  let(:server_port) { 80                }

  let(:proxy) do
    described_class.new(
      port: port,
      host: host,
      server: [server_host, server_port]
    )
  end

  subject { proxy }

  describe "#initialize" do
    it "must default host to '0.0.0.0'" do
      proxy = described_class.new(
        port: port,
        server: [server_host, server_port]
      )

      expect(proxy.port).to eq(port)
      expect(proxy.host).to eq('0.0.0.0')
    end

    it "must allow setting both the host and port" do
      proxy = described_class.new(
        port: port,
        host: host,
        server: [server_host, server_port]
      )

      expect(proxy.port).to eq(port)
      expect(proxy.host).to eq(host)
    end

    it "must set the server_host and server_port" do
      proxy = described_class.new(
        port: port,
        host: host,
        server: [server_host, server_port]
      )

      expect(proxy.server_host).to eq(server_host)
      expect(proxy.server_port).to eq(server_port)
    end
  end

  describe "#on_data" do
    it "must call on_client_data" do
      expect(subject).to receive(:on_client_data)

      subject.on_data { |client,server,data| }
    end

    it "must call on_server_data" do
      expect(subject).to receive(:on_server_data)

      subject.on_data { |client,server,data| }
    end
  end

  describe "actions" do
    describe "#ignore!" do
      it "must throw the :ignore action" do
        expect {
          subject.ignore!
        }.to throw_symbol(:action, :ignore)
      end
    end

    describe "#close!" do
      it "must throw the :close action" do
        expect {
          subject.close!
        }.to throw_symbol(:action, :close)
      end
    end

    describe "#reset!" do
      it "must throw the :reset action" do
        expect {
          subject.reset!
        }.to throw_symbol(:action, :reset)
      end
    end

    describe "#stop!" do
      it "must throw the :stop action" do
        expect {
          subject.stop!
        }.to throw_symbol(:action, :stop)
      end
    end
  end

  describe "#to_s" do
    subject { proxy.to_s }

    it "must include the proxy host and port" do
      expect(subject).to include("#{host}:#{port}")
    end

    it "must include the server host and port" do
      expect(subject).to include("#{server_host}:#{server_port}")
    end
  end

  describe "#inspect" do
    subject { proxy.inspect }

    it "must include the output of #to_s" do
      expect(subject).to include(proxy.to_s)
    end
  end
end
