require 'spec_helper'
require 'ronin/support/network/ssl/proxy'
require 'ronin/support/network/ssl/mixin'

describe Ronin::Support::Network::SSL::Proxy do
  let(:port)   { 1337        }
  let(:host)   { 'localhost' }
  let(:server) { ['www.example.com', 443] }

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }
  let(:key_file)     { File.join(fixtures_dir,'ssl.key') }
  let(:key)          { Ronin::Support::Crypto::Key::RSA.load_file(key_file) }
  let(:cert_file)    { File.join(fixtures_dir,'ssl.crt') }
  let(:cert)         { Ronin::Support::Crypto::Cert.load_file(cert_file) }

  before do
    allow(Ronin::Support::Network::SSL).to receive(:key).and_return(key)
    allow(Ronin::Support::Network::SSL).to receive(:cert).and_return(cert)
  end

  subject do
    described_class.new(
      port:   port,
      host:   host,
      server: server
    )
  end

  it { expect(described_class).to be < Ronin::Support::Network::Proxy }

  describe "#initialize" do
    it "must default #version to nil" do
      expect(subject.version).to be(nil)
    end

    context "when given the version: keyword argument" do
      let(:version) { 1.2 }

      subject do
        described_class.new(
          port:    port,
          host:    host,
          server:  server,
          version: version
        )
      end

      it "must set #version" do
        expect(subject.version).to eq(version)
      end
    end

    it "must default #key to Ronin::Support::Network::SSL.key" do
      expect(Ronin::Support::Network::SSL).to receive(:key).and_return(key)

      expect(subject.key).to be(key)
    end

    context "when given the key: keyword argument" do
      subject do
        described_class.new(
          port:    port,
          host:    host,
          server:  server,
          key:     key
        )
      end

      it "must set #key" do
        expect(subject.key).to be(key)
      end
    end

    it "must default #key_file to nil" do
      expect(subject.key_file).to be(nil)
    end

    context "when given the key_file: keyword argument" do
      subject do
        described_class.new(
          port:     port,
          host:     host,
          server:   server,
          key_file: key_file
        )
      end

      it "must set #key_file" do
        expect(subject.key_file).to be(key_file)
      end
    end

    it "must default #cert to Ronin::Support::Network::SSL.cert" do
      expect(Ronin::Support::Network::SSL).to receive(:cert).and_return(cert)

      expect(subject.cert).to be(cert)
    end

    context "when given the cert: keyword argument" do
      subject do
        described_class.new(
          port:   port,
          host:   host,
          server: server,
          cert:   cert
        )
      end

      it "must set #cert" do
        expect(subject.cert).to be(cert)
      end
    end

    it "must default #cert_file to nil" do
      expect(subject.cert_file).to be(nil)
    end

    context "when given the cert_file: certword argument" do
      subject do
        described_class.new(
          port:     port,
          host:     host,
          server:   server,
          cert_file: cert_file
        )
      end

      it "must set #cert_file" do
        expect(subject.cert_file).to be(cert_file)
      end
    end

    it "must default #verify to :none" do
      expect(subject.verify).to be(:none)
    end

    context "when given the verify: keyword argument" do
      let(:verify) { :peer }

      subject do
        described_class.new(
          port:   port,
          host:   host,
          server: server,
          verify: verify
        )
      end

      it "must set #verify" do
        expect(subject.verify).to be(verify)
      end
    end

    it "must default #ca_bundle to nil" do
      expect(subject.ca_bundle).to be(nil)
    end

    context "when given the ca_bundle: keyword argument" do
      let(:ca_bundle) { File.join(fixtures_dir,'ca_bundle') }

      subject do
        described_class.new(
          port:      port,
          host:      host,
          server:    server,
          ca_bundle: ca_bundle
        )
      end

      it "must set #ca_bundle" do
        expect(subject.ca_bundle).to be(ca_bundle)
      end
    end

    context "when given a block" do
      it "must yield the new instance of the #{described_class}" do
        expect { |b|
          described_class.new(
            port:      port,
            host:      host,
            server:    server,
            &b
          )
        }.to yield_with_args(described_class)
      end
    end
  end

  describe "integration", :network do
    include Ronin::Support::Network::SSL::Mixin

    let(:request) { "GET / HTTP/1.1\r\nHost: #{server[0]}\r\nConnection: close\r\n\r\n" }

    before(:each) do
      @proxy  = described_class.new(
        port:   port,
        host:   host,
        server: server
      )
      @thread = Thread.new { @proxy.start }

      sleep 0.1
    end

    describe "#on_client_connect" do
      let(:injection) { "Client connected\r\n" }

      before do
        @proxy.on_client_connect do |client|
          client.write(injection)
        end

        @socket = ssl_connect(host,port)
      end

      it "must trigger when a new client connects" do
        expect(@socket.readline).to eq(injection)
      end

      after { @socket.close }
    end

    describe "#on_server_connect" do
      let(:injection) { "Server connected\r\n" }

      before do
        @proxy.on_server_connect do |client,server|
          client.write(injection)
        end

        @socket = ssl_connect(host,port)
      end

      it "must trigger after a new client connects" do
        expect(@socket.readline).to eq(injection)
      end

      after { @socket.close }
    end

    describe "#on_client_data" do
      before do
        @proxy.on_client_data do |client,server,data|
          data.gsub!('GET /','GET /foo')
        end

        @socket = ssl_connect(host,port)
      end

      it "must trigger when the client sends data" do
        @socket.write(request)

        expect(@socket.readline).to eq("HTTP/1.1 404 Not Found\r\n")
      end

      after { @socket.close }
    end

    describe "#on_server_data" do
      before do
        @proxy.on_server_data do |client,server,data|
          data.gsub!(/HTTP\/\d\.\d/,'HTTP 9000')
        end

        @socket = ssl_connect(host,port)
      end

      it "must trigger when the server sends data" do
        @socket.write(request)

        expect(@socket.readline).to include("HTTP 9000 200 OK\r\n")
      end

      after { @socket.close }
    end

    describe "#on_server_disconnect" do
      let(:injection) { "Haha Internet!\r\n" }

      before do
        @proxy.on_server_disconnect do |client,server|
          client.write(injection)
        end

        @socket = ssl_connect(host,port)
      end

      it "must trigger when the server closes the connection" do
        @socket.write(request)

        expect(@socket.read.end_with?(injection)).to be(true)
      end

      after { @socket.close }
    end

    after(:each) do
      @thread.kill
      @proxy.close
    end
  end
end
