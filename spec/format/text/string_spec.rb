require 'spec_helper'
require 'ronin/support/format/text'

describe String do
  subject { "hello" }

  it "must provide String#format_chars" do
    expect(subject).to respond_to(:format_chars)
  end

  it "must provide String#format_bytes" do
    expect(subject).to respond_to(:format_bytes)
  end

  it "must provide String#random_case" do
    expect(subject).to respond_to(:random_case)
  end

  it "must provide String#insert_before" do
    expect(subject).to respond_to(:insert_before)
  end

  it "must provide String#insert_after" do
    expect(subject).to respond_to(:insert_after)
  end

  it "must provide String#escape" do
    expect(subject).to respond_to(:escape)
  end

  it "must provide String#unescape" do
    expect(subject).to respond_to(:unescape)
  end

  describe "#format_bytes" do
    it "must format each byte in the String" do
      expect(subject.format_bytes { |b|
        sprintf("%%%x",b)
      }).to eq("%68%65%6c%6c%6f")
    end

    it "must format specific bytes in a String" do
      expect(subject.format_bytes(include: [104, 108]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format specific bytes in a String" do
      expect(subject.format_bytes(exclude: [101, 111]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must format ranges of bytes in a String" do
      expect(subject.format_bytes(include: (104..108)) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format ranges of bytes in a String" do
      expect(subject.format_bytes(exclude: (104..108)) { |b|
        b - 32
      }).to eq('hEllO')
    end
  end

  describe "#format_chars" do
    it "must format each character in the String" do
      expect(subject.format_chars { |c|
        "#{c}."
      }).to eq("h.e.l.l.o.")
    end

    it "must format specific chars in a String" do
      expect(subject.format_chars(include: ['h', 'l']) { |c|
        c.upcase
      }).to eq('HeLLo')
    end

    it "must not format specific chars in a String" do
      expect(subject.format_chars(exclude: ['h', 'l']) { |c|
        c.upcase
      }).to eq('hEllO')
    end
  end

  describe "#random_case" do
    it "must capitalize each character when :probability is 1.0" do
      new_string = subject.random_case(probability: 1.0)

      expect(subject.upcase).to eq(new_string)
    end

    it "must not capitalize any characters when :probability is 0.0" do
      new_string = subject.random_case(probability: 0.0)

      expect(subject).to eq(new_string)
    end
  end

  describe "#insert_before" do
    it "must inject data before a matched String" do
      expect(subject.insert_before('ll','x')).to eq("hexllo")
    end

    it "must inject data before a matched Regexp" do
      expect(subject.insert_before(/l+/,'x')).to eq("hexllo")
    end

    it "must not inject data if no matches are found" do
      expect(subject.insert_before(/x/,'x')).to eq(subject)
    end
  end

  describe "#insert_after" do
    it "must inject data after a matched String" do
      expect(subject.insert_after('ll','x')).to eq("hellxo")
    end

    it "must inject data after a matched Regexp" do
      expect(subject.insert_after(/l+/,'x')).to eq("hellxo")
    end

    it "must not inject data if no matches are found" do
      expect(subject.insert_after(/x/,'x')).to eq(subject)
    end
  end

  describe "#unescape" do
    it "must not unescape a normal String" do
      expect("hello".unescape).to eq("hello")
    end

    it "must unescape a hex String" do
      expect("\\x68\\x65\\x6c\\x6c\\x6f\\x4e".unescape).to eq("hello\x4e")
    end

    it "must unescape an octal String" do
      expect("hello\\012".unescape).to eq("hello\n")
    end

    it "must unescape control characters" do
      expect("hello\\n".unescape).to eq("hello\n")
    end

    it "must unescape normal characters" do
      expect("hell\\o".unescape).to eq("hello")
    end
  end
end
