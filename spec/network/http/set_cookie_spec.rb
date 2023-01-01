require 'spec_helper'
require 'ronin/support/network/http/set_cookie'

describe Ronin::Support::Network::HTTP::SetCookie do
  let(:name1)  { "foo" }
  let(:value1) { "bar" }
  let(:name2)  { "baz" }
  let(:value2) { "qux" }

  let(:max_age)   { 63072000 }
  let(:expires)   { Time.parse("Sat, 13 Jul 2024 20:59:26 GMT") }
  let(:path)      { '/' }
  let(:domain)    { '.twitter.com' }
  let(:http_only) { false }
  let(:secure)    { true }
  let(:same_site) { :none }

  let(:params) do
    {name1 => value1, name2 => value2}
  end

  subject do
    described_class.new(params, expires:   expires,
                                max_age:   max_age,
                                path:      path,
                                domain:    domain,
                                secure:    secure,
                                same_site: same_site)
  end

  describe "#initialize" do
    subject { described_class.new(params) }

    it "must set #params" do
      expect(subject.params).to be(params)
    end

    context "when the expires: keyword argument is given" do
      subject { described_class.new(params, expires: expires) }

      it "must set #expires" do
        expect(subject.expires).to be(expires)
      end
    end

    context "when the max_age: keyword argument is given" do
      subject { described_class.new(params, max_age: max_age) }

      it "must set #max_age" do
        expect(subject.max_age).to be(max_age)
      end
    end

    context "when the path: keyword argument is given" do
      subject { described_class.new(params, path: path) }

      it "must set #path" do
        expect(subject.path).to be(path)
      end
    end

    context "when the domain: keyword argument is given" do
      subject { described_class.new(params, domain: domain) }

      it "must set #domain" do
        expect(subject.domain).to be(domain)
      end
    end

    context "when the http_only: keyword argument is given" do
      let(:http_only) { true }

      subject { described_class.new(params, http_only: http_only) }

      it "must set #http_only" do
        expect(subject.http_only).to be(http_only)
      end
    end

    context "when the secure: keyword argument is given" do
      subject { described_class.new(params, secure: secure) }

      it "must set #secure" do
        expect(subject.secure).to be(secure)
      end
    end

    context "when the same_site: keyword argument is given" do
      subject { described_class.new(params, same_site: same_site) }

      it "must set #same_site" do
        expect(subject.same_site).to be(same_site)
      end
    end
  end

  describe ".parse" do
    subject { described_class.parse(string) }

    context "when the string contains only one name=value pair" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}" }

      it "must parse the one name=value pair" do
        expect(subject.params[name]).to eq(value)
      end
    end

    context "when the string contains multiple name=value pairs separated by ';' characters" do
      let(:name1)  { "foo" }
      let(:value1) { "bar" }
      let(:name2)  { "baz" }
      let(:value2) { "qux" }
      let(:string) { "#{name1}=#{value1}; #{name2}=#{value2}" }

      it "must parse the name=value pairs" do
        expect(subject.params[name1]).to eq(value1)
        expect(subject.params[name2]).to eq(value2)
      end
    end

    context "when the name is URI encoded" do
      let(:encoded_name) { "foo%20bar" }
      let(:name)         { "foo bar" }
      let(:value)        { "qux" }
      let(:string)       { "#{encoded_name}=#{value}" }

      it "must URI decode the cookie param names" do
        expect(subject.params[name]).to eq(value)
      end
    end

    context "when the value is URI encoded" do
      let(:name)          { "foo" }
      let(:encoded_value) { "bar%20baz" }
      let(:value)         { "bar baz" }
      let(:string)        { "#{name}=#{encoded_value}" }

      it "must URI decode the cookie param names" do
        expect(subject.params[name]).to eq(value)
      end
    end

    context "when the string contains 'Max-Age=...'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; Max-Age=#{max_age}" }

      it "must parse 'Max-Age=...' and set #max_age" do
        expect(subject.max_age).to eq(max_age)
      end
    end

    context "when the string contains 'Expires=...'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; Expires=#{expires.httpdate}" }

      it "must parse 'Expires=...' and set #expires" do
        expect(subject.expires).to eq(expires)
      end
    end

    context "when the string contains 'Path=...'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; Path=#{path}" }

      it "must parse 'Path=...' and set #path" do
        expect(subject.path).to eq(path)
      end
    end

    context "when the string contains 'Domain=...'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; Domain=#{domain}" }

      it "must parse 'Domain=...' and set #domain" do
        expect(subject.domain).to eq(domain)
      end
    end

    context "when the string contains 'SameSite=None'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; SameSite=None" }

      it "must parse 'SameSite=None' and set #same_site to :none" do
        expect(subject.same_site).to eq(:none)
      end
    end

    context "when the string contains 'SameSite=Strict'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; SameSite=Strict" }

      it "must parse 'SameSite=Strict' and set #same_site to :strict" do
        expect(subject.same_site).to eq(:strict)
      end
    end

    context "when the string contains 'SameSite=Lax'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; SameSite=Lax" }

      it "must parse 'SameSite=Lax' and set #same_site to :lax" do
        expect(subject.same_site).to eq(:lax)
      end
    end

    context "when the string contains 'HttpOnly'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; HttpOnly" }

      it "must parse 'HttpOnly' and set #http_only to true" do
        expect(subject.http_only).to be(true)
      end
    end

    context "when the string contains 'Secure'" do
      let(:name)   { "foo" }
      let(:value)  { "bar" }
      let(:string) { "#{name}=#{value}; Secure" }

      it "must parse 'Secure' and set #secure to true" do
        expect(subject.secure).to be(true)
      end
    end
  end

  describe "#http_only?" do
    context "when initialized with `http_only: true`" do
      subject { described_class.new(params, http_only: true) }

      it "must return true" do
        expect(subject.http_only?).to be(true)
      end
    end

    context "whne initialized with `http_only: false`" do
      subject { described_class.new(params, http_only: false) }

      it "must return false" do
        expect(subject.http_only?).to be(false)
      end
    end

    context "whne not initialized with the http_only: keyword argument" do
      subject { described_class.new(params) }

      it "must return false" do
        expect(subject.http_only?).to be(false)
      end
    end
  end

  describe "#secure?" do
    context "when initialized with `secure: true`" do
      subject { described_class.new(params, secure: true) }

      it "must return true" do
        expect(subject.secure?).to be(true)
      end
    end

    context "whne initialized with `secure: false`" do
      subject { described_class.new(params, secure: false) }

      it "must return false" do
        expect(subject.secure?).to be(false)
      end
    end

    context "whne not initialized with the secure: keyword argument" do
      subject { described_class.new(params) }

      it "must return false" do
        expect(subject.secure?).to be(false)
      end
    end
  end

  describe "#to_s" do
    subject { described_class.new(params) }

    it "must the name=value params in the String" do
      expect(subject.to_s).to eq("#{name1}=#{value1}; #{name2}=#{value2}")
    end

    context "when initialized with the max_age: keyword argument" do
      subject { described_class.new(params, max_age: max_age) }

      it "must include 'Max-Age=...' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; Max-Age=#{max_age}"
        )
      end
    end

    context "when initialized with the expires: keyword argument" do
      subject { described_class.new(params, expires: expires) }

      it "must include 'Expires=...' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; Expires=#{expires.httpdate}"
        )
      end
    end

    context "when initialized with the path: keyword argument" do
      subject { described_class.new(params, path: path) }

      it "must include 'Path=...' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; Path=#{path}"
        )
      end
    end

    context "when initialized with the domain: keyword argument" do
      subject { described_class.new(params, domain: domain) }

      it "must include 'Domain=...' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; Domain=#{domain}"
        )
      end
    end

    context "when initialized with `same_site: :none`" do
      subject { described_class.new(params, same_site: :none) }

      it "must include 'SameSite=None' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; SameSite=None"
        )
      end
    end

    context "when initialized with `same_site: :strict`" do
      subject { described_class.new(params, same_site: :strict) }

      it "must include 'SameSite=Strict' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; SameSite=Strict"
        )
      end
    end

    context "when initialized with `same_site: :lax`" do
      subject { described_class.new(params, same_site: :lax) }

      it "must include 'SameSite=Lax' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; SameSite=Lax"
        )
      end
    end

    context "when initialized with `http_only: true`" do
      subject { described_class.new(params, http_only: true) }

      it "must include 'HttpOnly' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; HttpOnly"
        )
      end
    end

    context "when initialized with `secure: true`" do
      subject { described_class.new(params, secure: true) }

      it "must include 'Secure' in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; Secure"
        )
      end
    end

    context "when initialized with multiple keyword arguments" do
      subject do
        described_class.new(params, expires:   expires,
                                    max_age:   max_age,
                                    path:      path,
                                    domain:    domain,
                                    secure:    secure,
                                    same_site: same_site)
      end

      it "must include multiple attributes and flags in the String" do
        expect(subject.to_s).to eq(
          "#{name1}=#{value1}; #{name2}=#{value2}; Max-Age=#{max_age}; Expires=#{expires.httpdate}; Path=#{path}; Domain=#{domain}; SameSite=None; Secure"
        )
      end
    end
  end
end
