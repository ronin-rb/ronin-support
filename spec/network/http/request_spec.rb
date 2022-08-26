require 'spec_helper'
require 'ronin/support/network/http/request'

describe Ronin::Support::Network::HTTP::Request do
  describe ".request_uri" do
    let(:path) { '/foo' }

    context "when only given a path argument" do
      it "must return the path argument" do
        expect(subject.request_uri(path)).to eq(path)
      end
    end

    context "when given a path and a query: keyword argument" do
      let(:query) { "id=1" }

      it "must join the two usin a '?' character" do
        expect(subject.request_uri(path, query: query)).to eq(
          "#{path}?#{query}"
        )
      end

      context "when the path already contains a '?' character" do
        let(:path) { "/foo?bar=2" }

        it "must append the query string to the path using a '&' character" do
          expect(subject.request_uri(path, query: query)).to eq(
            "#{path}&#{query}"
          )
        end
      end
    end

    context "when given a path and a query_params: keyword argument" do
      let(:query_params) do
        {id: 1, bar: 2}
      end
      let(:query_string) { "id=1&bar=2" }

      it "must convert the query_params into a String and add it to the path" do
        expect(subject.request_uri(path, query_params: query_params)).to eq(
          "#{path}?#{query_string}"
        )
      end

      context "when the path already contains a '?' character" do
        let(:path) { "/foo?bar=2" }

        it "must append the query params to the path using a '&' character" do
          expect(subject.request_uri(path, query_params: query_params)).to eq(
            "#{path}&#{query_string}"
          )
        end
      end
    end
  end

  describe "METHODS" do
    subject { described_class::METHODS }

    describe ":copy" do
      it "must map to Net::HTTP::Copy" do
        expect(subject[:copy]).to be(Net::HTTP::Copy)
      end
    end

    describe ":delete" do
      it "must map to Net::HTTP::Delete" do
        expect(subject[:delete]).to be(Net::HTTP::Delete)
      end
    end

    describe ":get" do
      it "must map to Net::HTTP::Get" do
        expect(subject[:get]).to be(Net::HTTP::Get)
      end
    end

    describe ":head" do
      it "must map to Net::HTTP::Head" do
        expect(subject[:head]).to be(Net::HTTP::Head)
      end
    end

    describe ":lock" do
      it "must map to Net::HTTP::Lock" do
        expect(subject[:lock]).to be(Net::HTTP::Lock)
      end
    end

    describe ":mkcol" do
      it "must map to Net::HTTP::Mkcol" do
        expect(subject[:mkcol]).to be(Net::HTTP::Mkcol)
      end
    end

    describe ":move" do
      it "must map to Net::HTTP::Move" do
        expect(subject[:move]).to be(Net::HTTP::Move)
      end
    end

    describe ":options" do
      it "must map to Net::HTTP::Options" do
        expect(subject[:options]).to be(Net::HTTP::Options)
      end
    end

    describe ":patch" do
      it "must map to Net::HTTP::Patch" do
        expect(subject[:patch]).to be(Net::HTTP::Patch)
      end
    end

    describe ":post" do
      it "must map to Net::HTTP::Post" do
        expect(subject[:post]).to be(Net::HTTP::Post)
      end
    end

    describe ":propfind" do
      it "must map to Net::HTTP::Propfind" do
        expect(subject[:propfind]).to be(Net::HTTP::Propfind)
      end
    end

    describe ":proppatch" do
      it "must map to Net::HTTP::Proppatch" do
        expect(subject[:proppatch]).to be(Net::HTTP::Proppatch)
      end
    end

    describe ":put" do
      it "must map to Net::HTTP::Put" do
        expect(subject[:put]).to be(Net::HTTP::Put)
      end
    end

    describe ":trace" do
      it "must map to Net::HTTP::Trace" do
        expect(subject[:trace]).to be(Net::HTTP::Trace)
      end
    end

    describe ":unlock" do
      it "must map to Net::HTTP::Unlock" do
        expect(subject[:unlock]).to be(Net::HTTP::Unlock)
      end
    end
  end

  describe ".build" do
    let(:path) { '/foo' }

    it "must return a Net::HTTPRequest object with the #path set" do
      request = subject.build(:get, path)

      expect(request).to be_kind_of(Net::HTTPRequest)
      expect(request.path).to eq(path)
    end

    context "when given a method argument of :copy" do
      subject { super().build(:copy, '/') }

      it "must create HTTP Copy requests" do
        expect(subject.class).to eq(Net::HTTP::Copy)
      end
    end

    context "when given a method argument of :delete" do
      subject { super().build(:delete, '/') }

      it "must create HTTP Delete requests" do
        expect(subject.class).to eq(Net::HTTP::Delete)
      end
    end

    context "when given a method argument of :get" do
      subject { super().build(:get, '/') }

      it "must create HTTP Get requests" do
        expect(subject.class).to eq(Net::HTTP::Get)
      end
    end

    context "when given a method argument of :head" do
      subject { super().build(:head, '/') }

      it "must create HTTP Head requests" do
        expect(subject.class).to eq(Net::HTTP::Head)
      end
    end

    context "when given a method argument of :lock" do
      subject { super().build(:lock, '/') }

      it "must create HTTP Lock requests" do
        expect(subject.class).to eq(Net::HTTP::Lock)
      end
    end

    context "when given a method argument of :mkcol" do
      subject { super().build(:mkcol, '/') }

      it "must create HTTP Mkcol requests" do
        expect(subject.class).to eq(Net::HTTP::Mkcol)
      end
    end

    context "when given a method argument of :move" do
      subject { super().build(:move, '/') }

      it "must create HTTP Move requests" do
        expect(subject.class).to eq(Net::HTTP::Move)
      end
    end

    context "when given a method argument of :options" do
      subject { super().build(:options, '/') }

      it "must create HTTP Options requests" do
        expect(subject.class).to eq(Net::HTTP::Options)
      end
    end

    context "when given a method argument of :post" do
      subject { super().build(:post, '/') }

      it "must create HTTP Post requests" do
        expect(subject.class).to eq(Net::HTTP::Post)
      end
    end

    context "when given a method argument of :propfind" do
      subject { super().build(:propfind, '/') }

      it "must create HTTP Propfind requests" do
        expect(subject.class).to eq(Net::HTTP::Propfind)
      end
    end

    context "when given a method argument of :proppatch" do
      subject { super().build(:proppatch, '/') }

      it "must create HTTP Proppatch requests" do
        expect(subject.class).to eq(Net::HTTP::Proppatch)
      end
    end

    context "when given a method argument of :trace" do
      subject { super().build(:trace, '/') }

      it "must create HTTP Trace requests" do
        expect(subject.class).to eq(Net::HTTP::Trace)
      end
    end

    context "when given a method argument of :unlock" do
      subject { super().build(:unlock, '/') }

      it "must create HTTP Unlock requests" do
        expect(subject.class).to eq(Net::HTTP::Unlock)
      end
    end

    context "when given an unknown method name" do
      let(:method) { :foo }

      it do
        expect {
          subject.build(method, '/')
        }.to raise_error(ArgumentError,"unknown HTTP request method: #{method.inspect}")
      end
    end

    context "when given the query: keyword argument" do
      let(:query) { 'q=1' }

      it "must append the query-string to the path" do
        req = subject.build(:get,path, query: query)

        expect(req.path).to eq("#{path}?#{query}")
      end

      context "when path already contains a query string" do
        let(:additional_query) { 'x=2' }

        it "must append the query using a '&' character" do
          req = subject.build(:get,"#{path}?#{query}", query: additional_query)

          expect(req.path).to eq("#{path}?#{query}&#{additional_query}")
        end

        context "when :query is empty" do
          it "must append an extra '&'" do
            req = subject.build(:get,"#{path}?#{query}", query:  '')

            expect(req.path).to be_end_with('&')
          end
        end
      end

      context "when :query is empty" do
        it "must append an extra '?'" do
          req = subject.build(:get,path, query:  '')

          expect(req.path).to be_end_with('?')
        end
      end
    end

    context "when given the headers: keyword argument" do
      let(:header_name1)  { 'X-Foo' }
      let(:header_value1) { 'foo'   }
      let(:header_name2)  { 'X-Bar' }
      let(:header_value2) { 'bar'   }

      let(:headers) do
        {
          header_name1 => header_value1,
          header_name2 => header_value2
        }
      end

      it "must add the headers to the request" do
        req = subject.build(:get,path, headers: headers)

        expect(req[header_name1]).to eq(header_value1)
        expect(req[header_name2]).to eq(header_value2)
      end
    end

    context "when the cookie: keyword argument is given" do
      context "and the value is a String" do
        let(:cookie) { "foo=bar; baz=qux" }

        it "must set the `Cookie:` header with the given String" do
          req = subject.build(:get,path, cookie: cookie)

          expect(req['Cookie']).to eq(cookie)
        end
      end

      context "and the value is a Hash" do
        let(:cookie_hash) do
          {'foo' => 'bar', 'baz' => 'qux'}
        end
        let(:cookie) do
          Ronin::Support::Network::HTTP::Cookie.new(cookie_hash).to_s
        end

        it "must format and send the `Cookie:` header using the given Hash" do
          req = subject.build(:get,path, cookie: cookie_hash)

          expect(req['Cookie']).to eq(cookie)
        end
      end
    end

    context "when given the query_params: keyword argument" do
      let(:query_params) do
        {id: 1, bar: 2}
      end
      let(:query_string) { "id=1&bar=2" }

      it "must convert the query_params into a String and add it to the path" do
        req = subject.build(:get,path, query_params: query_params)

        expect(req.path).to eq("#{path}?#{query_string}")
      end

      context "when the path already contains a '?' character" do
        let(:path) { "/foo?bar=2" }

        it "must append the query params to the path using a '&' character" do
          req = subject.build(:get,path, query_params: query_params)

          expect(req.path).to eq("#{path}&#{query_string}")
        end
      end
    end

    context "when given the user: keyword argument" do
      it "must accept the :user option for Basic-Auth" do
        req = subject.build(:get,path, user: 'joe')

        expect(req['authorization']).to eq("Basic am9lOg==")
      end

      context "when also given the password: keyword argument" do
        it "must also accept the :password options for Basic-Auth" do
          req = subject.build(:get,path, user: 'joe', password: 'secret')

          expect(req['authorization']).to eq("Basic am9lOnNlY3JldA==")
        end
      end
    end

    context "when given the :body keyword argument" do
      context "and when it is a String" do
        let(:body) { "foo bar baz" }

        it "must set the request's #body" do
          req = subject.build(:get,path, body: body)

          expect(req.body).to be(body)
        end
      end

      context "when the :body value is an IO object" do
        let(:body) { File.new(__FILE__) }

        it "must set the request's #body_stream" do
          req = subject.build(:get,path, body: body)

          expect(req.body_stream).to be(body)
        end
      end

      context "when the :body value is an StringIO object" do
        let(:body) { StringIO.new('foo bar baz') }

        it "must set the request's #body_stream" do
          req = subject.build(:get,path, body: body)

          expect(req.body_stream).to be(body)
        end
      end
    end

    context "when given the form_data: keyword argument" do
      subject { super().build(:post,'/', form_data: form_data) }

      context "but it's a String value" do
        let(:form_data) { "foo=1&bar=2" }

        it "must set the content_type of the request to 'application/x-www-form-urlencoded'" do
          expect(subject.content_type).to eq('application/x-www-form-urlencoded')
        end

        it "must set the body of the request" do
          expect(subject.body).to eq(form_data)
        end
      end

      context "and it's a Hash" do
        let(:form_data) do
          {'foo' => 1, 'bar' => 2}
        end

        it "must set the body of the request to the encoded form data" do
          expect(subject.body).to eq(URI.encode_www_form(form_data))
        end
      end

      context "and it's an Array of Arrays" do
        let(:form_data) do
          [['foo', 1], ['bar', 2]]
        end

        it "must set the body of the request to the encoded form data" do
          expect(subject.body).to eq(URI.encode_www_form(form_data))
        end
      end
    end
  end
end
