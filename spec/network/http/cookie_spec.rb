require 'spec_helper'
require 'ronin/support/network/http/cookie'

describe Ronin::Support::Network::HTTP::Cookie do
  let(:name1)  { "foo" }
  let(:value1) { "bar" }
  let(:name2)  { "baz" }
  let(:value2) { "qux" }

  let(:params) do
    {name1 => value1, name2 => value2}
  end

  subject { described_class.new(params) }

  describe "#initialize" do
    it "must set #params" do
      expect(subject.params).to be(params)
    end

    context "when given no arguments" do
      subject { described_class.new }

      it "must default #params to an empty Hash" do
        expect(subject.params).to eq({})
      end
    end
  end

  describe "#initialize_copy" do
    let(:other) { described_class.new(params) }

    subject { other.clone }

    it "must copy the #params of the other cookie" do
      expect(subject.params).to_not be(params)
      expect(subject.params).to eq(params)
    end
  end

  describe ".escape" do
    subject { described_class }

    it "must convert ';' to '%3B'" do
      expect(subject.escape(';')).to eq('%3B')
    end

    it "must convert '=' to '%3D'" do
      expect(subject.escape('=')).to eq('%3D')
    end

    it "must convert '+' to '%2B'" do
      expect(subject.escape('+')).to eq('%2B')
    end

    it "must convert '\"' to '%22'" do
      expect(subject.escape('"')).to eq('%22')
    end

    it "must convert all control characters" do
      [*(0..31), *(127..255)].each do |byte|
        expect(subject.escape(byte.chr)).to eq("%%%.2X" % byte)
      end
    end

    it "must not convert alpha-numeric characters" do
      [*('A'..'Z'), *('a'..'z'), *('0'..'9')].each do |char|
        expect(subject.escape(char)).to eq(char)
      end
    end
  end

  describe ".unescape" do
    subject { described_class }

    it "must convert '+' to ' '" do
      expect(subject.unescape('+')).to eq(' ')
    end

    it "must convert '%XX' characters back into characters" do
      expect(subject.unescape('%20')).to eq(' ')
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
  end

  describe "#has_param?" do
    let(:name) { "foo" }
    let(:params) do
      {name => "bar"}
    end

    context "when the cookie contains a param with the given name" do
      it "must return true" do
        expect(subject.has_param?(name)).to be(true)
      end

      context "but the given name is a Symbol" do
        it "must convert the Symbol into a String" do
          expect(subject.has_param?(name.to_sym)).to be(true)
        end
      end
    end

    context "when the cookie does not contain a param with the given name" do
      it "must return false" do
        expect(subject.has_param?('other')).to be(false)
      end
    end
  end

  describe "#[]" do
    let(:name)  { "foo" }
    let(:value) { "bar" }
    let(:params) do
      {name => value}
    end

    context "when the cookie contains a param with the given name" do
      it "must return the corresponding value" do
        expect(subject[name]).to eq(value)
      end

      context "but the given name is a Symbol" do
        it "must convert the Symbol into a String" do
          expect(subject[name.to_sym]).to eq(value)
        end
      end
    end

    context "when the cookie does not contain a param with the given name" do
      it "must return nil" do
        expect(subject['other']).to be(nil)
      end
    end
  end

  describe "#[]=" do
    context "when the cookie already contains a param with the given name" do
      let(:name)      { name2 }
      let(:new_value) { "new value" }

      before { subject[name] = new_value }

      it "must overwrite the param value with the new value" do
        expect(subject[name]).to eq(new_value)
      end

      it "must return the new param value" do
        expect(subject[name] = new_value).to be(new_value)
      end

      context "when the name is a Symbol" do
        let(:name) { super().to_sym }

        it "must convert the name to a String before setting the param" do
          expect(subject[name.to_s]).to eq(new_value)
        end
      end

      context "when the value is not a String" do
        let(:new_value) { super().to_sym }

        it "must convert the value to a String before setting the param" do
          expect(subject[name]).to eq(new_value.to_s)
        end
      end
    end

    context "when the value is nil" do
      let(:name) { name2 }

      before { subject[name] = nil }

      it "must delete the param with the given name" do
        expect(subject[name]).to be(nil)
      end

      it "must return nil" do
        expect(subject[name] = nil).to be(nil)
      end

      context "when the name is a Symbol" do
        let(:name) { super().to_sym }

        it "must convert the name to a String before deleting the param" do
          expect(subject[name.to_s]).to be(nil)
        end
      end
    end
  end

  describe "#each" do
    context "when a block is given" do
      it "must yield each param name and value pair in the cookie" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args([name1,value1], [name2,value2])
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for the #each method" do
        expect(subject.each.to_a).to eq(
          [[name1,value1], [name2,value2]]
        )
      end
    end
  end

  describe "#merge!" do
    let(:new_name1)  { 'A' }
    let(:new_value1) { '1' }
    let(:new_name2)  { 'B' }
    let(:new_value2) { '2' }
    let(:new_params) do
      {new_name1 => new_value1, new_name2 => new_value2}
    end

    before { subject.merge!(new_params) }

    it "must insert the new params into the cookie" do
      expect(subject[new_name1]).to eq(new_value1)
      expect(subject[new_name2]).to eq(new_value2)
    end

    it "must return self" do
      expect(subject.merge!(new_params)).to be(subject)
    end

    context "when some of the params overlap with the existing params" do
      let(:new_name1) { name2 }

      it "must overwrite the existing params with the same name" do
        expect(subject[new_name1]).to eq(new_value1)
        expect(subject[name2]).to     eq(new_value1)
      end
    end
  end

  describe "#merge" do
    let(:new_name1)  { 'A' }
    let(:new_value1) { '1' }
    let(:new_name2)  { 'B' }
    let(:new_value2) { '2' }
    let(:new_params) do
      {new_name1 => new_value1, new_name2 => new_value2}
    end

    let(:original) { described_class.new(params) }

    subject { original.merge(new_params) }

    it "must insert the new params into the cookie" do
      expect(subject[new_name1]).to eq(new_value1)
      expect(subject[new_name2]).to eq(new_value2)
    end

    it "must return a new #{described_class}" do
      expect(subject).to be_kind_of(described_class)
      expect(subject).to_not be(original)
    end

    it "must not modify the original params Hash" do
      expect(original.params[new_name1]).to be(nil)
      expect(original.params[new_name2]).to be(nil)
    end

    context "when some of the params overlap with the existing params" do
      let(:new_name1) { name2 }

      it "must overwrite the existing params with the same name" do
        expect(subject[new_name1]).to eq(new_value1)
        expect(subject[name2]).to     eq(new_value1)
      end

      it "must not overwrite the original params Hash" do
        expect(original.params[new_name1]).to eq(value2)
        expect(original.params[name2]).to eq(value2)
      end
    end
  end

  describe "#empty?" do
    context "when #params is empty" do
      let(:params) do
        {}
      end

      it "must return true" do
        expect(subject.empty?).to be(true)
      end
    end

    context "when #params is not empty" do
      it "must return false" do
        expect(subject.empty?).to be(false)
      end
    end
  end

  describe "#to_h" do
    it "must return #params" do
      expect(subject.to_h).to eq(params)
    end
  end

  describe "#to_s" do
    context "when the cookie contains only one param" do
      let(:name)  { "foo" }
      let(:value) { "bar" }
      let(:params) do
        {name => value}
      end

      it "must return name=value pair" do
        expect(subject.to_s).to eq("#{name}=#{value}")
      end

      context "when the param name contain special URI characters" do
        let(:name)         { "foo bar" }
        let(:encoded_name) { "foo+bar" }
        let(:value)        { "qux"     }

        it "must URI encode the param names" do
          expect(subject.to_s).to eq("#{encoded_name}=#{value}")
        end
      end

      context "when the param value contain special URI characters" do
        let(:value)         { "foo bar" }
        let(:encoded_value) { "foo+bar" }

        it "must URI encode the param values" do
          expect(subject.to_s).to eq("#{name1}=#{encoded_value}")
        end
      end
    end

    context "when the cookie contians multiple params" do
      it "must format the #params back into name=value pairs separated by ';' characters" do
        expect(subject.to_s).to eq("#{name1}=#{value1}; #{name2}=#{value2}")
      end

      context "when the param names contain special URI characters" do
        let(:name1)         { "foo bar" }
        let(:encoded_name1) { "foo+bar" }
        let(:name2)         { "bar baz" }
        let(:encoded_name2) { "bar+baz" }

        it "must URI encode the param names" do
          expect(subject.to_s).to eq("#{encoded_name1}=#{value1}; #{encoded_name2}=#{value2}")
        end
      end

      context "when the param values contain special URI characters" do
        let(:value1)         { "foo bar" }
        let(:encoded_value1) { "foo+bar" }
        let(:value2)         { "bar baz" }
        let(:encoded_value2) { "bar+baz" }

        it "must URI encode the param values" do
          expect(subject.to_s).to eq("#{name1}=#{encoded_value1}; #{name2}=#{encoded_value2}")
        end
      end
    end
  end
end
