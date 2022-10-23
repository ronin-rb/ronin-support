require 'spec_helper'
require 'ronin/support/encoding/http/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#http_escape" do
    expect(subject).to respond_to(:http_escape)
  end

  it "must provide String#http_unescape" do
    expect(subject).to respond_to(:http_encode)
  end

  it "must provide String#http_encode" do
    expect(subject).to respond_to(:http_encode)
  end

  it "must provide String#http_decode" do
    expect(subject).to respond_to(:http_encode)
  end

  describe "#http_escape" do
    subject { "mod % 3" }

    let(:http_escaped) { "mod+%25+3" }

    it "must escape special characters as '%XX'" do
      expect(subject.http_escape).to eq(http_escaped)
    end

    context "when given `case: :lower`" do
      subject { "\xff" }

      let(:http_encoded) { '%ff'  }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.http_escape(case: :lower)).to eq(http_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { "\xff" }

      let(:http_encoded) { '%FF'  }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.http_escape(case: :upper)).to eq(http_encoded)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "mod % 3\xfe\xff" }

      let(:http_escaped) { "mod+%25+3%FE%FF" }

      it "must HTTP escape each byte in the String" do
        expect(subject.http_escape).to eq(http_escaped)
      end
    end
  end

  describe "#http_unescape" do
    subject { "mod %25 3" }
    
    let(:http_unescaped) { "mod % 3" }

    it "must unescape '%XX' characters" do
      expect(subject.http_unescape).to eq(http_unescaped)
    end
  end

  describe "#http_encode" do
    subject { "mod % 3" }

    let(:http_encoded) { "%6D%6F%64%20%25%20%33" }

    it "must format each byte of the String" do
      expect(subject.http_encode).to eq(http_encoded)
    end

    context "when given `case: :lower`" do
      subject { "\xff" }

      let(:http_encoded) { '%ff'  }

      it "must return a lowercase hexadecimal escaped String" do
        expect(subject.http_encode(case: :lower)).to eq(http_encoded)
      end
    end

    context "when given `case: :upper`" do
      subject { "\xff" }

      let(:http_encoded) { '%FF'  }

      it "must return a uppercase hexadecimal escaped String" do
        expect(subject.http_encode(case: :upper)).to eq(http_encoded)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "mod % 3\xfe\xff" }

      let(:http_encoded) { "%6D%6F%64%20%25%20%33%FE%FF" }

      it "must HTTP escape each byte in the String" do
        expect(subject.http_encode).to eq(http_encoded)
      end
    end
  end

  describe "#http_decode" do
    subject { "%41%42%43" }

    let(:http_decoded) { "ABC" }

    it "must decode each byte of the String" do
      expect(subject.http_decode).to eq(http_decoded)
    end
  end
end
