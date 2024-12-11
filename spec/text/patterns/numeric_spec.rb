require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/numeric'

describe Ronin::Support::Text::Patterns do
  describe "NUMBER" do
    subject { described_class::NUMBER }

    let(:number) { '0123456789' }

    it "must match one or more digits" do
      expect(number).to fully_match(subject)
    end
  end

  describe "OCTAL_BYTE" do
    subject { described_class::OCTAL_BYTE }

    it "must match 0 - 377" do
      numbers = (0..255).map { |byte| byte.to_s(8) }

      expect(numbers).to all(match(subject))
    end

    it "must not match numbers greater than 377" do
      expect('378').to_not match(subject)
    end
  end

  describe "DECIMAL_BYTE" do
    subject { described_class::DECIMAL_BYTE }

    it "must match 0 - 255" do
      numbers = (0..255).map(&:to_s)

      expect(numbers).to all(match(subject))
    end

    it "must not match numbers greater than 255" do
      expect('256').to_not match(subject)
    end
  end

  describe "DECIMAL_OCTET" do
    subject { described_class::DECIMAL_OCTET }

    it "must be an alias for DECIMAL_BYTE" do
      expect(subject).to be(described_class::DECIMAL_BYTE)
    end
  end

  describe "HEX_BYTE" do
    subject { described_class::HEX_BYTE }

    it "must match 00 - ff" do
      hex_bytes = (0..0xff).map { |byte| "%.2x" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must match 00 - FF" do
      hex_bytes = (0..0xff).map { |byte| "%.2X" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must match 0x00 - 0xff" do
      hex_bytes = (0..0xff).map { |byte| "0x%.2x" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must match 0x00 - 0xFF" do
      hex_bytes = (0..0xff).map { |byte| "0x%.2X" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must only match two hexadecimal digits" do
      string = "a1b2"

      expect(string[subject]).to eq("a1")
    end
  end

  describe "HEX_WORD" do
    subject { described_class::HEX_WORD }

    it "must match 0000 - ffff" do
      expect("0000").to match(subject)
      expect("ffff").to match(subject)
    end

    it "must match 0000 - FFFF" do
      expect("0000").to match(subject)
      expect("FFFF").to match(subject)
    end

    it "must match 0x0000 - 0xffff" do
      expect("0x0000").to match(subject)
      expect("0xffff").to match(subject)
    end

    it "must match 0x0000 - 0xFFFF" do
      expect("0x0000").to match(subject)
      expect("0xFFFF").to match(subject)
    end

    it "must only match four hexadecimal digits" do
      string = "a1b2c3"

      expect(string[subject]).to eq("a1b2")
    end
  end

  describe "HEX_DWORD" do
    subject { described_class::HEX_DWORD }

    it "must match 00000000 - ffffffff" do
      expect("00000000").to match(subject)
      expect("ffffffff").to match(subject)
    end

    it "must match 00000000 - FFFFFFFF" do
      expect("00000000").to match(subject)
      expect("FFFFFFFF").to match(subject)
    end

    it "must match 0x00000000 - 0xffffffff" do
      expect("0x00000000").to match(subject)
      expect("0xffffffff").to match(subject)
    end

    it "must match 0x00000000 - 0xFFFFFFFF" do
      expect("0x00000000").to match(subject)
      expect("0xFFFFFFFF").to match(subject)
    end

    it "must only match eight hexadecimal digits" do
      string = "1234abcdefg"

      expect(string[subject]).to eq("1234abcd")
    end
  end

  describe "HEX_QWORD" do
    subject { described_class::HEX_QWORD }

    it "must match 0000000000000000 - ffffffffffffffff" do
      expect("0000000000000000").to match(subject)
      expect("ffffffffffffffff").to match(subject)
    end

    it "must match 0000000000000000 - FFFFFFFFFFFFFFFF" do
      expect("0000000000000000").to match(subject)
      expect("FFFFFFFFFFFFFFFF").to match(subject)
    end

    it "must match 0x0000000000000000 - 0xffffffffffffffff" do
      expect("0x0000000000000000").to match(subject)
      expect("0xffffffffffffffff").to match(subject)
    end

    it "must match 0x0000000000000000 - 0xFFFFFFFFFFFFFFFF" do
      expect("0x0000000000000000").to match(subject)
      expect("0xFFFFFFFFFFFFFFFF").to match(subject)
    end

    it "must only match eight hexadecimal digits" do
      string = "1234567890abcdef11111"

      expect(string[subject]).to eq("1234567890abcdef")
    end
  end

  describe "HEX_NUMBER" do
    subject { described_class::HEX_NUMBER }

    it "must match one or more decimal digits" do
      number = "0123456789"

      expect(number).to fully_match(subject)
    end

    it "must match one or more lowercase hexadecimal digits" do
      hex = "0123456789abcdef"

      expect(hex).to fully_match(subject)
    end

    it "must match one or more uppercase hexadecimal digits" do
      hex = "0123456789ABCDEF"

      expect(hex).to fully_match(subject)
    end

    context "when the number begins with '0x'" do
      it "must match one or more decimal digits" do
        number = "0x0123456789"

        expect(number).to fully_match(subject)
      end

      it "must match one or more lowercase hexadecimal digits" do
        hex = "0x0123456789abcdef"

        expect(hex).to fully_match(subject)
      end

      it "must match one or more uppercase hexadecimal digits" do
        hex = "0x0123456789ABCDEF"

        expect(hex).to fully_match(subject)
      end
    end
  end

  describe "VERSION_NUMBER" do
    subject { described_class::VERSION_NUMBER }

    it "must match 'X.Y' versions" do
      version = '1.0'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y' versions" do
      version = '1.2.3'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y-Z' versions" do
      version = '1.2-3'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y_Z' versions" do
      version = '1.2_3'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.Z' versions" do
      version = '1.2.3.4'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-Z' versions" do
      version = '1.2.3-4'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y_Z' versions" do
      version = '1.2.3_4'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre' versions" do
      version = '1.2.3pre'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc' versions" do
      version = '1.2.3rc'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha' versions" do
      version = '1.2.3alpha'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta' versions" do
      version = '1.2.3beta'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yword' versions" do
      version = '1.2.3hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-pre' versions" do
      version = '1.2.3-pre'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rc' versions" do
      version = '1.2.3-rc'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alpha' versions" do
      version = '1.2.3-alpha'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-beta' versions" do
      version = '1.2.3-beta'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-word' versions" do
      version = '1.2.3-hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.pre' versions" do
      version = '1.2.3.pre'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rc' versions" do
      version = '1.2.3.rc'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alpha' versions" do
      version = '1.2.3.alpha'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.beta' versions" do
      version = '1.2.3.beta'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.word' versions" do
      version = '1.2.3.word'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YpreNNN' versions" do
      version = '1.2.3pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YrcNNN' versions" do
      version = '1.2.3rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YalphaNNN' versions" do
      version = '1.2.3alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YbetaNNN' versions" do
      version = '1.2.3beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YwordNNN' versions" do
      version = '1.2.3hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre-NNN' versions" do
      version = '1.2.3pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc-NNN' versions" do
      version = '1.2.3rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha-NNN' versions" do
      version = '1.2.3alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta-NNN' versions" do
      version = '1.2.3beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yword-NNN' versions" do
      version = '1.2.3hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre.NNN' versions" do
      version = '1.2.3pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc.NNN' versions" do
      version = '1.2.3rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha.NNN' versions" do
      version = '1.2.3alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta.NNN' versions" do
      version = '1.2.3beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yword.NNN' versions" do
      version = '1.2.3hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-preNNN' versions" do
      version = '1.2.3-pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rcNNN' versions" do
      version = '1.2.3-rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alphaNNN' versions" do
      version = '1.2.3-alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-betaNNN' versions" do
      version = '1.2.3-beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-xyzNNN' versions" do
      version = '1.2.3-hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.preNNN' versions" do
      version = '1.2.3.pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rcNNN' versions" do
      version = '1.2.3.rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alphaNNN' versions" do
      version = '1.2.3.alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.betaNNN' versions" do
      version = '1.2.3.beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.xyzNNN' versions" do
      version = '1.2.3.hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre-NNN' versions" do
      version = '1.2.3pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc-NNN' versions" do
      version = '1.2.3rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha-NNN' versions" do
      version = '1.2.3alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta-NNN' versions" do
      version = '1.2.3beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yxyz-NNN' versions" do
      version = '1.2.3hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-pre-NNN' versions" do
      version = '1.2.3-pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rc-NNN' versions" do
      version = '1.2.3-rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alpha-NNN' versions" do
      version = '1.2.3-alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-beta-NNN' versions" do
      version = '1.2.3-beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-xyz-NNN' versions" do
      version = '1.2.3-hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.pre-NNN' versions" do
      version = '1.2.3.pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rc-NNN' versions" do
      version = '1.2.3.rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alpha-NNN' versions" do
      version = '1.2.3.alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.beta-NNN' versions" do
      version = '1.2.3.beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.xyz-NNN' versions" do
      version = '1.2.3.hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre.NNN' versions" do
      version = '1.2.3pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc.NNN' versions" do
      version = '1.2.3rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha.NNN' versions" do
      version = '1.2.3alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta.NNN' versions" do
      version = '1.2.3beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yxyz.NNN' versions" do
      version = '1.2.3hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-pre.NNN' versions" do
      version = '1.2.3-pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rc.NNN' versions" do
      version = '1.2.3-rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alpha.NNN' versions" do
      version = '1.2.3-alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-beta.NNN' versions" do
      version = '1.2.3-beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-xyz.NNN' versions" do
      version = '1.2.3-hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.pre.NNN' versions" do
      version = '1.2.3.pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rc.NNN' versions" do
      version = '1.2.3.rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alpha.NNN' versions" do
      version = '1.2.3.alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.beta.NNN' versions" do
      version = '1.2.3.beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.xyz.NNN' versions" do
      version = '1.2.3.hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre' versions" do
      version = '1.2.3.4pre'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc' versions" do
      version = '1.2.3.4rc'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha' versions" do
      version = '1.2.3.4alpha'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta' versions" do
      version = '1.2.3.4beta'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zword' versions" do
      version = '1.2.3.4hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-pre' versions" do
      version = '1.2.3.4-pre'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rc' versions" do
      version = '1.2.3.4-rc'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alpha' versions" do
      version = '1.2.3.4-alpha'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-beta' versions" do
      version = '1.2.3.4-beta'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-xyz' versions" do
      version = '1.2.3.4-hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.pre' versions" do
      version = '1.2.3.4.pre'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rc' versions" do
      version = '1.2.3.4.rc'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alpha' versions" do
      version = '1.2.3.4.alpha'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.beta' versions" do
      version = '1.2.3.4.beta'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.word' versions" do
      version = '1.2.3.4.hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.ZpreNNN' versions" do
      version = '1.2.3.4pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.ZrcNNN' versions" do
      version = '1.2.3.4rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.ZalphaNNN' versions" do
      version = '1.2.3.4alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.ZbetaNNN' versions" do
      version = '1.2.3.4beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.ZwordNNN' versions" do
      version = '1.2.3.4hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre-NNN' versions" do
      version = '1.2.3.4pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc-NNN' versions" do
      version = '1.2.3.4rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha-NNN' versions" do
      version = '1.2.3.4alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta-NNN' versions" do
      version = '1.2.3.4beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zword-NNN' versions" do
      version = '1.2.3.4hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre.NNN' versions" do
      version = '1.2.3.4pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc.NNN' versions" do
      version = '1.2.3.4rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha.NNN' versions" do
      version = '1.2.3.4alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta.NNN' versions" do
      version = '1.2.3.4beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zword-NNN' versions" do
      version = '1.2.3.4hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-preNNN' versions" do
      version = '1.2.3.4-pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rcNNN' versions" do
      version = '1.2.3.4-rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alphaNNN' versions" do
      version = '1.2.3.4-alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-betaNNN' versions" do
      version = '1.2.3.4-beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-wordNNN' versions" do
      version = '1.2.3.4-hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.preNNN' versions" do
      version = '1.2.3.4.pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rcNNN' versions" do
      version = '1.2.3.4.rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alphaNNN' versions" do
      version = '1.2.3.4.alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.betaNNN' versions" do
      version = '1.2.3.4.beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.wordNNN' versions" do
      version = '1.2.3.4.hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre-NNN' versions" do
      version = '1.2.3.4pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc-NNN' versions" do
      version = '1.2.3.4rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha-NNN' versions" do
      version = '1.2.3.4alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta-NNN' versions" do
      version = '1.2.3.4beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zword-NNN' versions" do
      version = '1.2.3.4hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-pre-NNN' versions" do
      version = '1.2.3.4-pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rc-NNN' versions" do
      version = '1.2.3.4-rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alpha-NNN' versions" do
      version = '1.2.3.4-alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-beta-NNN' versions" do
      version = '1.2.3.4-beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-word-NNN' versions" do
      version = '1.2.3.4-hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.pre-NNN' versions" do
      version = '1.2.3.4.pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rc-NNN' versions" do
      version = '1.2.3.4.rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alpha-NNN' versions" do
      version = '1.2.3.4.alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.beta-NNN' versions" do
      version = '1.2.3.4.beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.word-NNN' versions" do
      version = '1.2.3.4.hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre.NNN' versions" do
      version = '1.2.3.4pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc.NNN' versions" do
      version = '1.2.3.4rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha.NNN' versions" do
      version = '1.2.3.4alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta.NNN' versions" do
      version = '1.2.3.4beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zword.NNN' versions" do
      version = '1.2.3.4hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-pre.NNN' versions" do
      version = '1.2.3.4-pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rc.NNN' versions" do
      version = '1.2.3.4-rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alpha.NNN' versions" do
      version = '1.2.3.4-alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-beta.NNN' versions" do
      version = '1.2.3.4-beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-word.NNN' versions" do
      version = '1.2.3.4-hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.pre.NNN' versions" do
      version = '1.2.3.4.pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rc.NNN' versions" do
      version = '1.2.3.4.rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alpha.NNN' versions" do
      version = '1.2.3.4.alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.beta.NNN' versions" do
      version = '1.2.3.4.beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.word.NNN' versions" do
      version = '1.2.3.4.hotfix.123'

      expect(version).to fully_match(subject)
    end

    context "when the version ends with a '+XXX' suffix" do
      it "must not match the '+XXX' suffix" do
        version = '1.2.3+a1b2c3'

        expect(version[subject]).to eq('1.2.3')
      end
    end

    it "must not accidentally match a phone number" do
      expect('1-800-111-2222').to_not match(subject)
    end

    it "must not accidentally match 'MM-DD-YY'" do
      expect('01-02-24').to_not match(subject)
    end

    it "must not accidentally match 'MM-DD-YYYY'" do
      expect('01-02-2024').to_not match(subject)
    end

    it "must not accidentally match 'YYYY-MM-DD'" do
      expect('2024-01-02').to_not match(subject)
    end

    it "must not accidentally match 'CVE-YYYY-XXXX'" do
      expect('CVE-2024-1234').to_not match(subject)
    end

    context "when the version is within a filename" do
      let(:version) { '1.2.3' }

      %w[.tar.gz .tar.bz2 .tar.xz .tgz .tbz2 .zip .rar .htm .html .xml .txt].each do |extname|
        context "and when the filename ends with '#{extname}'" do
          let(:extname)  { extname }
          let(:filename) { "foo-#{version}#{extname}" }

          it "must not accidentally match '#{extname}' as part of the version" do
            expect(filename[subject]).to eq(version)
          end
        end
      end
    end
  end
end
