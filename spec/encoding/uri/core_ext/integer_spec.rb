require 'spec_helper'
require 'ronin/support/encoding/uri/core_ext/integer'

describe Integer do
  subject { 0x20 }

  it { expect(subject).to respond_to(:uri_encode) }
  it { expect(subject).to respond_to(:uri_escape) }
  it { expect(subject).to respond_to(:uri_form_encode) }
  it { expect(subject).to respond_to(:uri_form_escape) }

  describe "#uri_encode" do
    subject { 0x41 }

    let(:uri_encoded) { '%41' }

    it "must URI encode the Integer" do
      expect(subject.uri_encode).to eq(uri_encoded)
    end
  end

  describe "#uri_escape" do
    context "when the Integer maps to a special character" do
      subject { 0x20 }

      let(:uri_escaped) { '%20' }

      it "must URI escape the Integer" do
        expect(subject.uri_escape).to eq(uri_escaped)
      end
    end

    context "when called on a printable ASCII character" do
      subject { 0x41 }

      it "must return that character" do
        expect(subject.uri_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      let(:uri_escaped) { '%FF' }

      it "must URI encode the Integer" do
        expect(subject.uri_escape).to eq(uri_escaped)
      end
    end

    context "when given the unsafe: keyword argument" do
      context "and the Integer is in the list of unsafe characters" do
        subject { 0x20 }

        let(:unsafe)      { [' ', "\n", "\r"] }
        let(:uri_encoded) { '%20' }

        it "must URI encode the Integer" do
          expect(subject.uri_escape(unsafe: unsafe)).to eq(uri_encoded)
        end
      end

      context "when the Integer is not in the list of unsafe characters" do
        subject { 0x20 }

        let(:unsafe) { %w[A B C] }

        it "must not encode itself if not listed as unsafe" do
          expect(subject.uri_escape(unsafe: unsafe)).to eq(subject.chr)
        end
      end
    end
  end

  describe "#uri_form_encode" do
    subject { 0x41 }

    let(:uri_form_encoded) { '%41' }

    it "must URI encode the Integer" do
      expect(subject.uri_form_encode).to eq(uri_form_encoded)
    end
  end

  describe "#uri_form_escape" do
    context "when the Integer is 0x20" do
      subject { 0x20 }

      it "must return '+'" do
        expect(subject.uri_form_escape).to eq('+')
      end
    end

    context "when the Integer maps to a special character" do
      subject { 0x23 } # '#'

      let(:uri_form_escaped) { '%23' }

      it "must URI escape the Integer" do
        expect(subject.uri_form_escape).to eq(uri_form_escaped)
      end
    end

    context "when called on a printable ASCII character" do
      subject { 0x41 }

      it "must return that character" do
        expect(subject.uri_form_escape).to eq(subject.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      subject { 0xFF }

      let(:uri_form_escaped) { '%FF' }

      it "must URI encode the Integer" do
        expect(subject.uri_form_escape).to eq(uri_form_escaped)
      end
    end
  end
end
