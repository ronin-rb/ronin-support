require 'spec_helper'
require 'ronin/support/network/http'

describe Network::HTTP do
  describe "proxy" do
    it "must be disabled by default" do
      expect(subject.proxy).to be(nil)
    end
  end

  describe "options_from" do
    let(:url) { URI('http://example.com:443/path?q=1') }

    it "must accept URI objects" do
      options = subject.options_from(url)

      expect(options[:host]).to eq(url.host)
    end

    it "must accept Hashes" do
      hash = {
        host: url.host,
        port: url.port,
      }
      options = subject.options_from(hash)

      expect(options[:host]).to eq(url.host)
      expect(options[:port]).to eq(url.port)
    end

    it "must accept Strings" do
      options = subject.options_from(url.to_s)

      expect(options[:host]).to eq(url.host)
      expect(options[:port]).to eq(url.port)
    end

    describe ":path" do
      it "must filter out empty URL paths" do
        options = subject.options_from(URI('http://example.com'))

        expect(options[:path]).to be_nil
      end

      context "when the path is empty" do
        it "must not be set" do
          options = subject.options_from(URI('http://example.com'))

          expect(options).not_to have_key(:path)
        end
      end
    end

    describe ":query" do
      it "must set :query to the query string" do
        options = subject.options_from(url)

        expect(options[:query]).to eq(url.query)
      end

      context "when query is nil" do
        it "must not be set" do
          options = subject.options_from(URI('http://example.com/path'))

          expect(options).not_to have_key(:query)
        end
      end

      context "when query is empty" do
        it "must be set" do
          options = subject.options_from(URI('http://example.com/path?'))

          expect(options[:query]).to be_empty
        end
      end
    end

    it "must set :ssl if the URI scheme is 'https'" do
      options = subject.options_from(URI('https://example.com'))

      expect(options[:ssl]).to eq({})
    end
  end

  describe "normalize_options" do
    it "must expand the :ssl option into a Hash" do
      options = {ssl: true}
      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:ssl]).to eq({})
    end

    it "must added a default port and path" do
      options = {host: 'example.com'}
      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:port]).to eq(80)
      expect(expanded_options[:path]).to eq('/')
    end

    it "must add the default proxy settings" do
      options = {host: 'example.com'}
      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:proxy]).to eq(subject.proxy)
    end

    it "must disable the proxy settings if :proxy is nil" do
      options = {host: 'example.com', proxy: nil}
      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:proxy]).to be(nil)
    end

    it "must not modify :proxy if it is a URI::HTTP object" do
      proxy   = URI::HTTP.build(host: 'proxy.com', port: 8181)
      options = {host: 'example.com', proxy: proxy}

      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:proxy]).to be(proxy)
    end

    it "must parse the :proxy option if it is a String object" do
      options = {host: 'example.com', proxy: 'http://proxy.com:8181'}
      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:proxy]).to be_kind_of(URI::HTTP)
      expect(expanded_options[:proxy].host).to eq('proxy.com')
      expect(expanded_options[:proxy].port).to eq(8181)
    end

    it "must expand the :url option" do
      options = {url: 'http://joe:secret@example.com:8080/bla?var'}
      expanded_options = subject.normalize_options(options)

      expect(expanded_options[:url]).to be_nil
      expect(expanded_options[:host]).to eq('example.com')
      expect(expanded_options[:port]).to eq(8080)
      expect(expanded_options[:user]).to eq('joe')
      expect(expanded_options[:password]).to eq('secret')
      expect(expanded_options[:path]).to eq('/bla')
      expect(expanded_options[:query]).to eq('var')
    end
  end

  describe "headers" do
    it "must convert Symbol options to HTTP Headers" do
      options = {user_agent: 'bla', location: 'test'}

      expect(subject.headers(options)).to eq({
        'User-Agent' => 'bla',
        'Location'   => 'test'
      })
    end

    it "must convert String options to HTTP Headers" do
      options = {'user_agent' => 'bla', 'x-powered-by' => 'PHP'}

      expect(subject.headers(options)).to eq({
        'User-Agent'   => 'bla',
        'X-Powered-By' => 'PHP'
      })
    end

    it "must convert all values to Strings" do
      mtime = Time.now.to_i
      options = {modified_by: mtime, x_accept: :gzip}

      expect(subject.headers(options)).to eq({
        'Modified-By' => mtime.to_s,
        'X-Accept'    => 'gzip'
      })
    end
  end

  describe "request" do
    it "must handle Symbol names" do
      expect(subject.request(
        method: :get, path: '/'
      ).class).to eq(Net::HTTP::Get)
    end

    it "must handle String names" do
      expect(subject.request(
        method: 'GET', path: '/'
      ).class).to eq(Net::HTTP::Get)
    end

    context "with :path" do
      it "must use a default path" do
        expect {
          subject.request(method: :get)
        }.not_to raise_error
      end

      it "must set the path" do
        req = subject.request(method: :get, path: '/foo')

        expect(req.path).to eq('/foo')
      end
    end

    context "with :query" do
      let(:path)  { '/foo' }
      let(:query) { 'q=1' }

      it "must append the query-string to the path" do
        req = subject.request(
          method: :get,
          path:   path,
          query:  query
        )

        expect(req.path).to eq("#{path}?#{query}")
      end

      context "when path already contains a query string" do
        let(:additional_query) { 'x=2' }

        it "must append the query using a '&' character" do
          req = subject.request(
            method: :get,
            path:   "#{path}?#{query}",
            query:  additional_query
          )

          expect(req.path).to eq("#{path}?#{query}&#{additional_query}")
        end

        context "when :query is empty" do
          it "must append an extra '&'" do
            req = subject.request(
              method: :get,
              path:   "#{path}?#{query}",
              query:  ''
            )

            expect(req.path).to be_end_with('&')
          end
        end
      end

      context "when :query is empty" do
        it "must append an extra '?'" do
          req = subject.request(
            method: :get,
            path:   path,
            query:  ''
          )

          expect(req.path).to be_end_with('?')
        end
      end
    end

    context "with :user and :password" do
      it "must accept the :user option for Basic-Auth" do
        req = subject.request(method: :get, user: 'joe')

        expect(req['authorization']).to eq("Basic am9lOg==")
      end

      it "must also accept the :password options for Basic-Auth" do
        req = subject.request(
          method:   :get,
          user:     'joe',
          password: 'secret'
        )

        expect(req['authorization']).to eq("Basic am9lOnNlY3JldA==")
      end
    end

    context "with :method" do
      it "must create HTTP Copy requests" do
        req = subject.request(method: :copy)

        expect(req.class).to eq(Net::HTTP::Copy)
      end

      it "must create HTTP Delete requests" do
        req = subject.request(method: :delete)

        expect(req.class).to eq(Net::HTTP::Delete)
      end

      it "must create HTTP Get requests" do
        req = subject.request(method: :get)

        expect(req.class).to eq(Net::HTTP::Get)
      end

      it "must create HTTP Head requests" do
        req = subject.request(method: :head)

        expect(req.class).to eq(Net::HTTP::Head)
      end

      it "must create HTTP Lock requests" do
        req = subject.request(method: :lock)

        expect(req.class).to eq(Net::HTTP::Lock)
      end

      it "must create HTTP Mkcol requests" do
        req = subject.request(method: :mkcol)

        expect(req.class).to eq(Net::HTTP::Mkcol)
      end

      it "must create HTTP Move requests" do
        req = subject.request(method: :move)

        expect(req.class).to eq(Net::HTTP::Move)
      end

      it "must create HTTP Options requests" do
        req = subject.request(method: :options)

        expect(req.class).to eq(Net::HTTP::Options)
      end

      it "must create HTTP Post requests" do
        req = subject.request(method: :post)

        expect(req.class).to eq(Net::HTTP::Post)
      end

      it "must create HTTP Propfind requests" do
        req = subject.request(method: :propfind)

        expect(req.class).to eq(Net::HTTP::Propfind)
      end

      it "must create HTTP Proppatch requests" do
        req = subject.request(method: :proppatch)

        expect(req.class).to eq(Net::HTTP::Proppatch)
      end

      it "must create HTTP Trace requests" do
        req = subject.request(method: :trace)

        expect(req.class).to eq(Net::HTTP::Trace)
      end

      it "must create HTTP Unlock requests" do
        req = subject.request(method: :unlock)

        expect(req.class).to eq(Net::HTTP::Unlock)
      end

      it "must raise an UnknownRequest exception for invalid methods" do
        expect {
          subject.request(method: :bla)
        }.to raise_error(subject::UnknownRequest)
      end
    end

    it "must raise an ArgumentError when :method is not specified" do
      expect {
        subject.request()
      }.to raise_error(ArgumentError)
    end
  end
end
