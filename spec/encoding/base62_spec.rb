require 'spec_helper'
require 'ronin/support/encoding/base62'

describe Ronin::Support::Encoding::Base62 do
  describe ".encode_int" do
    subject { described_class }

    it "must convert 0 to '0'" do
      expect(subject.encode_int(0)).to eq('0')
    end

    it "must convert 1 to '1'" do
      expect(subject.encode_int(1)).to eq('1')
    end

    it "must convert 10 to 'A'" do
      expect(subject.encode_int(10)).to eq('A')
    end

    it "must convert 100 to '1c'" do
      expect(subject.encode_int(100)).to eq('1c')
    end

    it "must convert 1231 to 'Jr'" do
      expect(subject.encode_int(1231)).to eq('Jr')
    end

    it "must convert 3982 to '12E'" do
      expect(subject.encode_int(3982)).to eq('12E')
    end

    it "must convert 10927 to '2qF'" do
      expect(subject.encode_int(10927)).to eq('2qF')
    end

    it "must convert 50923 to 'DFL'" do
      expect(subject.encode_int(50923)).to eq('DFL')
    end

    it "must convert 100292 to 'Q5c'" do
      expect(subject.encode_int(100292)).to eq('Q5c')
    end

    it "must convert 202731 to 'qjr'" do
      expect(subject.encode_int(202731)).to eq('qjr')
    end

    it "must convert 519278 to '2B5S'" do
      expect(subject.encode_int(519278)).to eq('2B5S')
    end

    it "must convert 902323 to '3mjb'" do
      expect(subject.encode_int(902323)).to eq('3mjb')
    end

    it "must convert 1003827 to '4D8l'" do
      expect(subject.encode_int(1003827)).to eq('4D8l')
    end

    it "must convert 2129387 to '8vwx'" do
      expect(subject.encode_int(2129387)).to eq('8vwx')
    end

    it "must convert 52338283 to '3XbZr'" do
      expect(subject.encode_int(52338283)).to eq('3XbZr')
    end

    it "must convert 298372887 to 'KBwPv'" do
      expect(subject.encode_int(298372887)).to eq('KBwPv')
    end

    it "must convert 8237468237 to '8zTZmv'" do
      expect(subject.encode_int(8237468237)).to eq('8zTZmv')
    end

    it "must convert 256352386723872 to '1AnE6bpNA'" do
      expect(subject.encode_int(256352386723872)).to eq('1AnE6bpNA')
    end
  end

  describe ".decode" do
    subject { described_class }

    it "must convert '0' to 0" do
      expect(subject.decode('0')).to eq(0)
    end

    it "must convert '1' to 1" do
      expect(subject.decode('1')).to eq(1)
    end

    it "must convert 'A' to 10" do
      expect(subject.decode('A')).to eq(10)
    end

    it "must convert '1c' to 100" do
      expect(subject.decode('1c')).to eq(100)
    end

    it "must convert 'Jr' to 1231" do
      expect(subject.decode('Jr')).to eq(1231)
    end

    it "must convert '12E' to 3982" do
      expect(subject.decode('12E')).to eq(3982)
    end

    it "must convert '2qF' to 10927" do
      expect(subject.decode('2qF')).to eq(10927)
    end

    it "must convert 'DFL' to 50923" do
      expect(subject.decode('DFL')).to eq(50923)
    end

    it "must convert 'Q5c' to 100292" do
      expect(subject.decode('Q5c')).to eq(100292)
    end

    it "must convert 'qjr' to 202731" do
      expect(subject.decode('qjr')).to eq(202731)
    end

    it "must convert '2B5S' to 519278" do
      expect(subject.decode('2B5S')).to eq(519278)
    end

    it "must convert '3mjb' to 902323" do
      expect(subject.decode('3mjb')).to eq(902323)
    end

    it "must convert '4D8l' to 1003827" do
      expect(subject.decode('4D8l')).to eq(1003827)
    end

    it "must convert '8vwx' to 2129387" do
      expect(subject.decode('8vwx')).to eq(2129387)
    end

    it "must convert '3XbZr' to 52338283" do
      expect(subject.decode('3XbZr')).to eq(52338283)
    end

    it "must convert 'KBwPv' to 298372887" do
      expect(subject.decode('KBwPv')).to eq(298372887)
    end

    it "must convert '8zTZmv' to 8237468237" do
      expect(subject.decode('8zTZmv')).to eq(8237468237)
    end

    it "must convert '1AnE6bpNA' to 256352386723872" do
      expect(subject.decode('1AnE6bpNA')).to eq(256352386723872)
    end
  end
end
