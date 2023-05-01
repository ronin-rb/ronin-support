require 'spec_helper'
require 'ronin/support/encoding/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#encode_chars" do
    expect(subject).to respond_to(:encode_chars)
  end

  it "must provide String#encode_bytes" do
    expect(subject).to respond_to(:encode_bytes)
  end

  describe "#encode_bytes" do
    it "must format each byte in the String" do
      expect(subject.encode_bytes { |b|
        sprintf("%%%x",b)
      }).to eq("%68%65%6c%6c%6f")
    end

    it "must set the String encoding to Encoding::UTF_8" do
      new_string = subject.encode_bytes { |b| b + 1 }

      expect(new_string.encoding).to be(Encoding::UTF_8)
    end

    it "must format specific bytes in a String" do
      expect(subject.encode_bytes(include: [104, 108]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format specific bytes in a String" do
      expect(subject.encode_bytes(exclude: [101, 111]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must format ranges of bytes in a String" do
      expect(subject.encode_bytes(include: (104..108)) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format ranges of bytes in a String" do
      expect(subject.encode_bytes(exclude: (104..108)) { |b|
        b - 32
      }).to eq('hEllO')
    end
  end

  describe "#encode_chars" do
    it "must format each character in the String" do
      expect(subject.encode_chars { |c|
        "#{c}."
      }).to eq("h.e.l.l.o.")
    end

    it "must set the String encoding to Encoding::UTF_8" do
      new_string = subject.encode_chars { |c| c.upcase }

      expect(new_string.encoding).to be(Encoding::UTF_8)
    end

    it "must format specific chars in a String" do
      encoded = subject.encode_chars(include: ['h', 'l'], &:upcase)

      expect(encoded).to eq('HeLLo')
    end

    it "must not format specific chars in a String" do
      encoded = subject.encode_chars(exclude: ['h', 'l'], &:upcase)

      expect(encoded).to eq('hEllO')
    end
  end
end
