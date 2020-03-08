require 'spec_helper'
require 'ronin/formatting/extensions/sql/string'

describe String do
  let(:string) {'/etc/passwd' }
  let(:sql_encoded) { '0x2f6574632f706173737764' }
  let(:string_with_quotes) { %{"O'Brian"} }

  it "should provide the #sql_escape method" do
    expect(string).to respond_to(:sql_escape)
  end

  it "should provide the #sql_encode method" do
    expect(string).to respond_to(:sql_encode)
  end

  it "should provide the #sql_decode method" do
    expect(string).to respond_to(:sql_decode)
  end

  describe "#sql_escape" do
    it "should be able to single-quote escape" do
      expect(string_with_quotes.sql_escape(:single)).to eq(%{'"O''Brian"'})
    end

    it "should be able to double-quote escape" do
      expect(string_with_quotes.sql_escape(:double)).to eq(%{"""O'Brian"""})
    end

    it "should be able to tick-mark escape" do
      expect(string_with_quotes.sql_escape(:tick)).to eq(%{`"O'Brian"`})
    end
  end

  describe "#sql_encode" do
    it "should be able to be SQL-hex encoded" do
      expect(string.sql_encode).to eq(sql_encoded)
    end

    it "should return an empty String if empty" do
      expect(''.sql_encode).to eq('')
    end
  end

  describe "#sql_decode" do
    it "should be able to be SQL-hex decoded" do
      encoded = string.sql_encode

      expect(encoded).to eq(sql_encoded)
      expect(encoded.sql_decode).to eq(string)
    end

    it "should be able to decode SQL comma-escaping" do
      expect("'Conan O''Brian'".sql_decode).to eq("Conan O'Brian")
    end
  end

  describe "#sql_inject" do
    context "when there is a leading quote character" do
      it "should remove the first and last quote character" do
        expect("'1' OR '1'='1'".sql_inject).to eq("1' OR '1'='1")
      end

      context "when there is no matching leading/trailing quote characters" do
        it "should comment-terminate the String" do
          expect("'1' OR 1=1".sql_inject).to eq("1' OR 1=1--")
        end
      end
    end

    context "when there is no leading quote character" do
      it "should not modify the String" do
        expect("1 OR 1=1".sql_inject).to eq("1 OR 1=1")
      end
    end
  end
end
