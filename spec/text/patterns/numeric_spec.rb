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

  describe "DECIMAL_OCTET" do
    subject { described_class::DECIMAL_OCTET }

    it "must match 0 - 255" do
      numbers = (0..255).map(&:to_s)

      expect(numbers).to all(match(subject))
    end

    it "must not match numbers greater than 255" do
      expect('256').to_not match(subject)
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

    it "must match 'X.Y.Y.Z' versions" do
      version = '1.2.3.4'

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

    it "must match 'X.Y.Yxyz' versions" do
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

    it "must match 'X.Y.Y-xyz' versions" do
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

    it "must match 'X.Y.Y.xyz' versions" do
      version = '1.2.3.hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YpreXYZ' versions" do
      version = '1.2.3pre1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YrcXYZ' versions" do
      version = '1.2.3rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YalphaXYZ' versions" do
      version = '1.2.3alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YbetaXYZ' versions" do
      version = '1.2.3beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.YxyzXYZ' versions" do
      version = '1.2.3hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre-XYZ' versions" do
      version = '1.2.3pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc-XYZ' versions" do
      version = '1.2.3rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha-XYZ' versions" do
      version = '1.2.3alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta-XYZ' versions" do
      version = '1.2.3beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yxyz-XYZ' versions" do
      version = '1.2.3hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre.XYZ' versions" do
      version = '1.2.3pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc.XYZ' versions" do
      version = '1.2.3rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha.XYZ' versions" do
      version = '1.2.3alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta.XYZ' versions" do
      version = '1.2.3beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yxyz.XYZ' versions" do
      version = '1.2.3hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-preXYZ' versions" do
      version = '1.2.3-pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rcXYZ' versions" do
      version = '1.2.3-rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alphaXYZ' versions" do
      version = '1.2.3-alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-betaXYZ' versions" do
      version = '1.2.3-beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-xyzXYZ' versions" do
      version = '1.2.3-hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.preXYZ' versions" do
      version = '1.2.3.pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rcXYZ' versions" do
      version = '1.2.3.rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alphaXYZ' versions" do
      version = '1.2.3.alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.betaXYZ' versions" do
      version = '1.2.3.beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.xyzXYZ' versions" do
      version = '1.2.3.hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre-XYZ' versions" do
      version = '1.2.3pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc-XYZ' versions" do
      version = '1.2.3rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha-XYZ' versions" do
      version = '1.2.3alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta-XYZ' versions" do
      version = '1.2.3beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yxyz-XYZ' versions" do
      version = '1.2.3hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-pre-XYZ' versions" do
      version = '1.2.3-pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rc-XYZ' versions" do
      version = '1.2.3-rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alpha-XYZ' versions" do
      version = '1.2.3-alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-beta-XYZ' versions" do
      version = '1.2.3-beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-xyz-XYZ' versions" do
      version = '1.2.3-hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.pre-XYZ' versions" do
      version = '1.2.3.pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rc-XYZ' versions" do
      version = '1.2.3.rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alpha-XYZ' versions" do
      version = '1.2.3.alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.beta-XYZ' versions" do
      version = '1.2.3.beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.xyz-XYZ' versions" do
      version = '1.2.3.hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ypre.XYZ' versions" do
      version = '1.2.3pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yrc.XYZ' versions" do
      version = '1.2.3rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yalpha.XYZ' versions" do
      version = '1.2.3alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Ybeta.XYZ' versions" do
      version = '1.2.3beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Yxyz.XYZ' versions" do
      version = '1.2.3hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-pre.XYZ' versions" do
      version = '1.2.3-pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-rc.XYZ' versions" do
      version = '1.2.3-rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-alpha.XYZ' versions" do
      version = '1.2.3-alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-beta.XYZ' versions" do
      version = '1.2.3-beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y-xyz.XYZ' versions" do
      version = '1.2.3-hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.pre.XYZ' versions" do
      version = '1.2.3.pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.rc.XYZ' versions" do
      version = '1.2.3.rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.alpha.XYZ' versions" do
      version = '1.2.3.alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.beta.XYZ' versions" do
      version = '1.2.3.beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Y.xyz.XYZ' versions" do
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

    it "must match 'X.Y.Z.Y.Zxyz' versions" do
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

    it "must match 'X.Y.Z.Y.Z.xyz' versions" do
      version = '1.2.3.4.hotfix'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre.Y.ZZ' versions" do
      version = '1.2.3.4pre1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc.Y.ZZ' versions" do
      version = '1.2.3.4rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha.Y.ZZ' versions" do
      version = '1.2.3.4alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta.Y.ZZ' versions" do
      version = '1.2.3.4beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zxyz.Y.ZZ' versions" do
      version = '1.2.3.4hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre-.Y.ZZ' versions" do
      version = '1.2.3.4pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc-.Y.ZZ' versions" do
      version = '1.2.3.4rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha-.Y.ZZ' versions" do
      version = '1.2.3.4alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta-.Y.ZZ' versions" do
      version = '1.2.3.4beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zxyz-.Y.ZZ' versions" do
      version = '1.2.3.4hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre..Y.ZZ' versions" do
      version = '1.2.3.4pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc..Y.ZZ' versions" do
      version = '1.2.3.4rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha..Y.ZZ' versions" do
      version = '1.2.3.4alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta..Y.ZZ' versions" do
      version = '1.2.3.4beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zxyz..Y.ZZ' versions" do
      version = '1.2.3.4hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-pre.Y.ZZ' versions" do
      version = '1.2.3.4-pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rc.Y.ZZ' versions" do
      version = '1.2.3.4-rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alpha.Y.ZZ' versions" do
      version = '1.2.3.4-alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-beta.Y.ZZ' versions" do
      version = '1.2.3.4-beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-xyz.Y.ZZ' versions" do
      version = '1.2.3.4-hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.pre.Y.ZZ' versions" do
      version = '1.2.3.4.pre123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rc.Y.ZZ' versions" do
      version = '1.2.3.4.rc123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alpha.Y.ZZ' versions" do
      version = '1.2.3.4.alpha123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.beta.Y.ZZ' versions" do
      version = '1.2.3.4.beta123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.xyz.Y.ZZ' versions" do
      version = '1.2.3.4.hotfix123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre-.Y.ZZ' versions" do
      version = '1.2.3.4pre-1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc-.Y.ZZ' versions" do
      version = '1.2.3.4rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha-.Y.ZZ' versions" do
      version = '1.2.3.4alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta-.Y.ZZ' versions" do
      version = '1.2.3.4beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zxyz-.Y.ZZ' versions" do
      version = '1.2.3.4hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-pre-.Y.ZZ' versions" do
      version = '1.2.3.4-pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rc-.Y.ZZ' versions" do
      version = '1.2.3.4-rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alpha-.Y.ZZ' versions" do
      version = '1.2.3.4-alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-beta-.Y.ZZ' versions" do
      version = '1.2.3.4-beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-xyz-.Y.ZZ' versions" do
      version = '1.2.3.4-hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.pre-.Y.ZZ' versions" do
      version = '1.2.3.4.pre-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rc-.Y.ZZ' versions" do
      version = '1.2.3.4.rc-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alpha-.Y.ZZ' versions" do
      version = '1.2.3.4.alpha-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.beta-.Y.ZZ' versions" do
      version = '1.2.3.4.beta-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.xyz-.Y.ZZ' versions" do
      version = '1.2.3.4.hotfix-123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zpre..Y.ZZ' versions" do
      version = '1.2.3.4pre.1234'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zrc..Y.ZZ' versions" do
      version = '1.2.3.4rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zalpha..Y.ZZ' versions" do
      version = '1.2.3.4alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zbeta..Y.ZZ' versions" do
      version = '1.2.3.4beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Zxyz..Y.ZZ' versions" do
      version = '1.2.3.4hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-pre..Y.ZZ' versions" do
      version = '1.2.3.4-pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-rc..Y.ZZ' versions" do
      version = '1.2.3.4-rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-alpha..Y.ZZ' versions" do
      version = '1.2.3.4-alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-beta..Y.ZZ' versions" do
      version = '1.2.3.4-beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z-xyz..Y.ZZ' versions" do
      version = '1.2.3.4-hotfix.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.pre..Y.ZZ' versions" do
      version = '1.2.3.4.pre.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.rc..Y.ZZ' versions" do
      version = '1.2.3.4.rc.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.alpha..Y.ZZ' versions" do
      version = '1.2.3.4.alpha.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.beta..Y.ZZ' versions" do
      version = '1.2.3.4.beta.123'

      expect(version).to fully_match(subject)
    end

    it "must match 'X.Y.Z.Y.Z.xyz..Y.ZZ' versions" do
      version = '1.2.3.4.hotfix.123'

      expect(version).to fully_match(subject)
    end
  end
end
