require 'spec_helper'
require 'ronin/support/text/patterns'

describe Ronin::Support::Text::Patterns do
  RSpec::Matchers.define :fully_match do |expected|
    match do |actual|
      expect(actual.match(expected)[0]).to eq(actual)
    end

    description do
      "to fully match #{expected.inspect}"
    end
  end

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

  describe "MD5" do
    subject { described_class::MD5 }

    let(:md5) { "5d41402abc4b2a76b9719d911017c592" }

    it "must match hex strings with 32 characters" do
      string = md5

      expect(string).to fully_match(subject)
    end

    it "must match MD5 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{md5}"

      expect(string[subject]).to eq(md5)
    end

    it "must match MD5 checksums starting with other alpha characters" do
      string = "XXX#{md5}"

      expect(string[subject]).to eq(md5)
    end

    it "must match MD5 checksums ending with other non-alpha-numeric characters" do
      string = "#{md5} Foo"

      expect(string[subject]).to eq(md5)
    end

    it "must match MD5 checksums ending with other alpha characters" do
      string = "#{md5}XXX"

      expect(string[subject]).to eq(md5)
    end

    it "must not match a hex string longer than 32 characters" do
      string = "000#{md5}000"

      expect(string).to_not match(subject)
    end
  end

  describe "SHA1" do
    subject { described_class::SHA1 }

    let(:sha1) { "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d" }

    it "must match hex strings with 40 characters" do
      string = sha1

      expect(string).to fully_match(subject)
    end

    it "must match SHA1 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{sha1}"

      expect(string[subject]).to eq(sha1)
    end

    it "must match SHA1 checksums starting with other alpha characters" do
      string = "XXX#{sha1}"

      expect(string[subject]).to eq(sha1)
    end

    it "must match SHA1 checksums ending with other non-alpha-numeric characters" do
      string = "#{sha1} Foo"

      expect(string[subject]).to eq(sha1)
    end

    it "must match SHA1 checksums ending with other alpha characters" do
      string = "#{sha1}XXX"

      expect(string[subject]).to eq(sha1)
    end

    it "must not match a hex string longer than 40 characters" do
      string = "000#{sha1}000"

      expect(string).to_not match(subject)
    end
  end

  describe "SHA256" do
    subject { described_class::SHA256 }

    let(:sha256) do
      "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
    end

    it "must match hex strings with 64 characters" do
      string = sha256

      expect(string).to fully_match(subject)
    end

    it "must match SHA256 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{sha256}"

      expect(string[subject]).to eq(sha256)
    end

    it "must match SHA256 checksums starting with other alpha characters" do
      string = "XXX#{sha256}"

      expect(string[subject]).to eq(sha256)
    end

    it "must match SHA256 checksums ending with other non-alpha-numeric characters" do
      string = "#{sha256} Foo"

      expect(string[subject]).to eq(sha256)
    end

    it "must match SHA256 checksums ending with other alpha characters" do
      string = "#{sha256}XXX"

      expect(string[subject]).to eq(sha256)
    end

    it "must not match a hex string longer than 64 characters" do
      string = "000#{sha256}000"

      expect(string).to_not match(subject)
    end
  end

  describe "SHA512" do
    subject { described_class::SHA512 }

    let(:sha512) do
      "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"
    end

    it "must match hex strings with 128 characters" do
      string = sha512

      expect(string).to fully_match(subject)
    end

    it "must match SHA512 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{sha512}"

      expect(string[subject]).to eq(sha512)
    end

    it "must match SHA512 checksums starting with other alpha characters" do
      string = "XXX#{sha512}"

      expect(string[subject]).to eq(sha512)
    end

    it "must match SHA512 checksums ending with other non-alpha-numeric characters" do
      string = "#{sha512} Foo"

      expect(string[subject]).to eq(sha512)
    end

    it "must match SHA512 checksums ending with other alpha characters" do
      string = "#{sha512}XXX"

      expect(string[subject]).to eq(sha512)
    end

    it "must not match a hex string longer than 128 characters" do
      string = "000#{sha512}000"

      expect(string).to_not match(subject)
    end
  end

  describe "HASH" do
    subject { described_class::HASH }

    it "must not match non-hex characters" do
      string = 'X' * 32

      expect(string).to_not match(subject)
    end

    it "must not match hex strings less than 32 characters" do
      string = "0123456789abcdef"

      expect(string).to_not match(subject)
    end

    it "must match hex strings with 32 characters" do
      string = "5d41402abc4b2a76b9719d911017c592"

      expect(string).to fully_match(subject)
    end

    it "must not match hex strings between 32 and 40 characters" do
      string = "005d41402abc4b2a76b9719d911017c59200"

      expect(string).to_not match(subject)
    end

    it "must match hex strings with 40 characters" do
      string = "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"

      expect(string).to fully_match(subject)
    end

    it "must not match hex strings between 40 and 64 characters" do
      string = "002cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b982400"

      expect(string).to_not match(subject)
    end

    it "must match hex strings with 64 characters" do
      string = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"

      expect(string).to fully_match(subject)
    end

    it "must not match hex strings between 64 and 128 characters" do
      string = "0002cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824000"

      expect(string).to_not match(subject)
    end

    it "must match hex strings with 128 characters" do
      string = "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"

      expect(string).to fully_match(subject)
    end

    it "must not match hex strings longer than 128 characters" do
      string = "000009b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec0430000000"

      expect(string).to_not match(subject)
    end
  end

  describe "SSH_PUBLIC_KEY" do
    subject { described_class::SSH_PUBLIC_KEY }

    it "must match 'ssh-rsa AAAA... user@domain'" do
      ssh_rsa_pubkey = <<~EOS.chomp
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQyYe+dnOTC+H/Mj6n40sNlNy64wspivT8RMrElDaBEiib+HAc9f66dCHN/27Z+sWoq0/p56hHIrsfztHLhFx51xr6/Z6UUnBmeCfP+Wm2lIWoQuepLY8/gsWNwD+Z01gMz9tciDsSbUrwybOLXY+69sTnM2PCDDvTWw5DPjHi6C1O/zJDWNBPy4fxBXpD+PK/Cx43m55emj5ZpLjQCrJvYPA5AL81R3swnBGkduvLNEMcwOaywLn5adTFsKLNwvIIUBmgZftFmTs46vlT0gxSek4E4s6fD5bJkdywu/my7vl56rPP+/kr3QjKfzfhhMR85uwQB37DPi3gu8Cqj7xp8z91cnfizVPpc5YyWgZteU12VphuU6iFJuaoQK9UFqhl5GZO1Ea8ul8k/4YaQRPdD5bUsl4tBYI4SE4ugHq1o/Homa2Syid02eCz6ILhhkk/kERnLNnlb8uoXtmuT7NQU0G52KRyEzKURLLfK+G+4d0TyEDfcVey1Q7Shhyt1KdfABdvtmugPUT0OZFpgABKDmhHJEsDazF8/6sQnAhxhDPz8tSgw60ecjBqPjFYzpfKXKjmZjTeZ7Whiv4R4oZA4Bmwkik9KfNTem8cmAmjZYUSrtS5isW0IHlIlxCMGYPMHec6CxxwpGPvgmjv+hcD9kuZeC8OePofWeLNfNOttQ== test@example.com
      EOS

      expect(ssh_rsa_pubkey).to fully_match(subject)
    end

    it "must match 'ssh-dss AAAA... user@domain'" do
      ssh_dsa_pubkey = <<~EOS.chomp
        ssh-dss AAAAB3NzaC1kc3MAAACBANTQuv28rnsPgMjQ0OBiuHYHeWdDs4iWEHkTTFSahtI+30dJQ1o8dTz38ZRy5WTIkrEC2h0WI6JjGI9anlCuOFUrxIKzotE7hjm6l7gbGygdg35zI/k8QsqCX/7pGEg7WyaQx0Y5GFl3QKzPini04ZvtyDi1C1i3OwcnjtR1yiY3AAAAFQCI7Wx0KjrHnZd4qEekHvBzWxkaOQAAAIBciaLycTTgopllldv2LjaCOlvdrCiuYPyYbwVQvpPwwuZB0CYpe9L+tvyPo3XyMvQi6xuETGzh5E0tiph0+HwUfmJV8VVZmqMInzIGNgKNP/wI1UPN2MRdzy6k3D1W/b0JL3wqzl3rIMl36lsKkvKWzL57vA9LMwKZFd+W8ELRUAAAAIEApasZdOkHW2stegT4CtASxvbY1GbQ03mQAhC9cLSOUmLwbentL7MHfW1UhD+MYRDn7+YbAxBPCqnc4goOHOt4TTKny8QAhY/BKiVhQGW0D33VmCctSjkMUZGqDI3yJPwEpmQjQFecqy4prD0ExjSWm4CyMQ4njcXG/Qf1F+gZMZ8= test@example.com
      EOS

      expect(ssh_dsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp256 AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~EOS.chomp
        ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF3ob/ktTVokdKx3E1UTDHW+60beSRSIsTfHHRHnaRAoQhaq8Y6bNk6f/48sHbFnE3AUEPwKomEQc+5wALjIbeQ= test@example.com
      EOS

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp384 AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~EOS.chomp
        ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBD2JcEAE50xLmN12XS2BF3KGRaOIy19A6Qc71eqCNPeW4cThk1AjLgDZmtny9sYffdt09wEjhqzijxtj2GDM/6IW/ox1tDCekAOVJ9H+y1BM8w31+oJnEgTpFQ1dUBO+hw== test@example.com
      EOS

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp521 AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~EOS.chomp
        ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGI+HpWu8ltNAHTZz3G0c88BsgMQH87/L6RG+jVb/Nrsdkn6nU95JvD3O24c/0RwuQxx/qxnleRb+T7oQbkMHELywDvNxv9U72MwG6d/GyKTHLIdEei+KpouMIE+jVRVlk7MczL9m/ocy8Ep+i/YAeefNshge4PZqsxxierY57t3T3UTg== test@example.com
      EOS

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp256@openssh.com AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~EOS.chomp
        ecdsa-sha2-nistp256@openssh.com AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF3ob/ktTVokdKx3E1UTDHW+60beSRSIsTfHHRHnaRAoQhaq8Y6bNk6f/48sHbFnE3AUEPwKomEQc+5wALjIbeQ= test@example.com
      EOS

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ssh-ed25519 AAAA... user@domain'" do
      ssh_ed25519_pubkey = <<~EOS.chomp
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKdiXXLq/ezeabNyv1AOdc4xeUQB41kbSCXBsq9hQ7X test@example.com
      EOS

      expect(ssh_ed25519_pubkey).to fully_match(subject)
    end

    it "must match 'ssh-ed25519@openssh.com AAAA... user@domain'" do
      ssh_ed25519_pubkey = <<~EOS.chomp
        ssh-ed25519@openssh.com AAAAC3NzaC1lZDI1NTE5AAAAIFKdiXXLq/ezeabNyv1AOdc4xeUQB41kbSCXBsq9hQ7X test@example.com
      EOS

      expect(ssh_ed25519_pubkey).to fully_match(subject)
    end
  end

  describe "PRIVATE_KEY" do
    subject { described_class::SSH_PRIVATE_KEY }

    let(:pem) do
      <<~EOS.chomp
        -----BEGIN OPENSSH PRIVATE KEY-----
        b3BlbnNzaC1rZXktdjEAAAAACmFlczI1Ni1jdHIAAAAGYmNyeXB0AAAAGAAAABD9PGSaAf
        Dq62GrgiZvZw2/AAAAEAAAAAEAAAGXAAAAB3NzaC1yc2EAAAADAQABAAABgQC7brcxQofg
        311DS9V5glazxTmO6yYW5uxZjTTjaJgC4lpi7e4NeTRh1pnt8nfvxMvvk4FV+Jy8KCMWP1
        DAEbQSUyHOi1d2Bh6y0AazluQMH4J0UAjbA7C/PZgg2s63yNeE4KDtd9+VMZMGvg+EluQg
        yKUHG4/hw17+QHF0oMv3UR5FUK9/gdYedKPETkhOV02MsB6otNTIpp86d1pGj81ku4XtcB
        m9yNBhEUvNEAeu55wy6KAzVdu9yh3RL+tyjOtUFujVlTdJoCDFOqfRre7xtTXCIROLl298
        FdS+B2+NF4ThBHnPsqCv/ouqlszWKmvv2xz0+VOuMHWbKIf+rdpgy+Zegn6IFAyPc0QEix
        eaq5KZLvPJDXZ7oFTbWzTRaSdKNultpg4Qr/e86Y2n2V3OnLq6FGeqKfsXBuT/T8pczVhY
        lzUzpOgphYvcAheJobjaUeNsHWD9ixa1rnFmu4uxS8FKbC2eIhpmTM3abjSUcwpey18CIn
        bTRgMin6sjIbMAAAWQZD6aUgnsO+6QR7wtTKGVw5vmhgwkyYYVZ6RjbYswmP7JqieiyxPR
        45rvwf7b3CCB/GBpz3yR/t3oeL/MNwda2DXFyNQe6otBXfBvESParQzk5qb7hKLqCpK3N7
        CLkW5IQU/S29xkbnIczkjM1EZqmwW33AyVQUm3gJcQ0X1gKwFNV6ZS6MXWXn1CEPc9kmjE
        9r6c/IS3/gExj66XyD5nAbk6DmIxrkJG+CeyLjD78R0Uz7+pAX23rYQ7UXtaaHvK234b+a
        tA/s8lO046ZJMaHJVeVmTGuvi/XE17IReaNXr1mH6iHq4vORZtp5V7IxrEgPYsjmGIRqy2
        mw+7vbmB2Re8RJaBSvcYiSwuJK5yUfa52iLSOcjp1ZnMBCW1hWtnOstZo/g+3wsEtQa5Kb
        bPePW1+t8aYb4+B5WSSrR87EWiqhDzFve1kOx9dbr0u9tf6Y1Sw0V486oMLATX5Pv/P/dG
        hHgiuK36/4s0RZyN/5CwIe3UB7kVTG2V2wlgIgvawPsX2S5zZRmIXbghpMr2NU7/bUhNY5
        r0R0XiCXOwN8g6LjFlgFDd4GeGhzprNCUg9l2XnEfc3yffR/QGm2VyW4ZzRcQk/bkGE9yx
        XNLZufkYPjooNLf+Xunj8yE3/JvsmLmHCKgbwxCEvuYkjRKZ32hcePyKC1b6pQuGiu8b7c
        TLshytoExu9cGLvnxU9gYLA4JaN3n57tkSasT8g2edmp04Un5gvuJZ88qqJn0iXHBA/fgc
        cHXb3f3obp0nse/KHewMRQ/EOsz7CY6G4n2PNXlq6UGh0cQTiWcH/58P5tj1GmA6FDv2eo
        eHhebXUwVLm8hovuYKmAvAm6oqXKr/OV7KiptV32tjgEdPrwQfry96JOuYhJSz2lj2NlG+
        iWpMzzZHEXr2IInZb/4yyg4vU4y1P3Rspr/IbHGFkqcepmRCn7yZb9QltZIqyL5j/L+PKm
        CW5+jRb144BQh4YGO1IMzw+gh/J5nbjpV1FIopAcAkNpoe2Ywfk5L5czukaNh1P7KoZBbK
        i/AQRannVplt2NvM0NqS0IrfkqEpCRqhdgA8kNTiN2oSlBuAicxuyC/VpQWk+uOmjmCyTx
        OTLIxKElCXrEG4z+yMHK9NV4yLJHCodwN+tBRrQJDNsNa8LOVYDdS3XU/PRGtzZNG8StWP
        XdpfhvkQBsuV414fZSUb6mXtGrf5IbldtfR9YcgaU7SpECW+NBqu866yUjDloIkFj2PVp1
        s5XrZwIdCEOYQ16etcdEmQ/QuGtd0PrRqoNkz78BpuYTx442sVcFVPYABGoS7JgfAP7tPY
        PKk+8YSoiw1bEuvxz4Ab1xuFfqBmGf9pil6M8FdxWnOjVlIG64KrpUq2iNSAzRglPtGLaE
        EJ9u3fRy6yEwEoD6j44xw9JIiGiBWwSFNyoy26c5tcLbuH8i3w27mvcI4HJzi9Zy/VEyHG
        VtyUTnCVRHRMOm+K0pil6+QZfB+hVI6Y4/rrISyKjw1G+mSMhFa8y3jHzFH8G8n6f1kGY0
        /L6YVrQED3WuKxaXqCevDIrNrXpgF4sSHFfTv0uXeDB+1HbyUP6mWqQznHSYmLnxyhsKL9
        GN8U7dkdJWyekS9pZdvM3CdSCvOJlPLluBo9qPGlIyZsi2GiG2DeuIjhVQcax7EGLZEO0F
        X4Zv+3LsSuKdFZ/bMk8ob0XXLoaDx6Djjzi6U7yVnJKKcsOEm954wyhyyfNQDfw5zvOjNQ
        E4ebjYwxDlALCNFLHnGzuZKmBxMIRbD+5WaYvhUoCrz76g94gZgF+jC/oOde7eETDM3A9L
        ghYR3dF7eoFzWSRT/dHJk6ilmVGL238hRLlyTbtfHk7UBymvjvAKWJAT/hIfD/w791iAd5
        L+swREJQgxmikV3PoMgaxuLhuak=
        -----END OPENSSH PRIVATE KEY-----
      EOS
    end

    it "must match the data between '-----BEGIN OPENSSH PRIVATE KEY-----' and '-----END OPENSSH PRIVATE KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN OPENSSH PRIVATE KEY-----' and '-----END OPENSSH PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN OPENSSH PRIVATE KEY-----
        -----END OPENSSH PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "AWS_ACCESS_KEY_ID" do
    subject { described_class::AWS_ACCESS_KEY_ID }

    let(:aws_access_key_id) { "AKIAIOSFODNN7EXAMPLE" }

    it "must match an uppercase alpha-numeric string with 20 characters" do
      string = aws_access_key_id

      expect(string).to fully_match(subject)
    end

    it "must match an AWS access key ID starting with other non-alpha-numeric characters" do
      string = "Foo: #{aws_access_key_id}"

      expect(string[subject]).to eq(aws_access_key_id)
    end

    it "must match AWS access key ID checksums ending with other non-alpha-numeric characters" do
      string = "#{aws_access_key_id} Foo"

      expect(string[subject]).to eq(aws_access_key_id)
    end

    it "must not match an uppercase alpha-numeric string longer than 20 characters" do
      string = "ABC123#{aws_access_key_id}ABC123"

      expect(string).to_not match(subject)
    end
  end

  describe "AWS_SECRET_ACCESS_KEY" do
    subject { described_class::AWS_SECRET_ACCESS_KEY }

    let(:aws_secret_access_key) { "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" }

    it "must match an uppercase alpha-numeric string with 20 characters" do
      string = aws_secret_access_key

      expect(string).to fully_match(subject)
    end

    it "must match an AWS secret access key starting with other non-alpha-numeric characters" do
      string = "Foo: #{aws_secret_access_key}"

      expect(string[subject]).to eq(aws_secret_access_key)
    end

    it "must match AWS secret access key checksums ending with other non-alpha-numeric characters" do
      string = "#{aws_secret_access_key} Foo"

      expect(string[subject]).to eq(aws_secret_access_key)
    end

    it "must not match an uppercase alpha-numeric string longer than 20 characters" do
      string = "ABC123#{aws_secret_access_key}ABC123"

      expect(string).to_not match(subject)
    end
  end

  describe "API_KEY" do
    subject { described_class::API_KEY }

    let(:md5) { "5d41402abc4b2a76b9719d911017c592" }

    it "must match MD5 checksums" do
      string = md5

      expect(string).to fully_match(subject)
    end

    it "must match MD5 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{md5}"

      expect(string[subject]).to eq(md5)
    end

    it "must match MD5 checksums starting with other alpha characters" do
      string = "XXX#{md5}"

      expect(string[subject]).to eq(md5)
    end

    it "must match MD5 checksums ending with other non-alpha-numeric characters" do
      string = "#{md5} Foo"

      expect(string[subject]).to eq(md5)
    end

    it "must match MD5 checksums ending with other alpha characters" do
      string = "#{md5}XXX"

      expect(string[subject]).to eq(md5)
    end

    it "must not match a hex string longer than 32 characters" do
      string = "000#{md5}000"

      expect(string).to_not match(subject)
    end

    let(:sha1) { "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d" }

    it "must match SHA1 checksums" do
      string = sha1

      expect(string).to fully_match(subject)
    end

    it "must match SHA1 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{sha1}"

      expect(string[subject]).to eq(sha1)
    end

    it "must match SHA1 checksums starting with other alpha characters" do
      string = "XXX#{sha1}"

      expect(string[subject]).to eq(sha1)
    end

    it "must match SHA1 checksums ending with other non-alpha-numeric characters" do
      string = "#{sha1} Foo"

      expect(string[subject]).to eq(sha1)
    end

    it "must match SHA1 checksums ending with other alpha characters" do
      string = "#{sha1}XXX"

      expect(string[subject]).to eq(sha1)
    end

    it "must not match a hex string longer than 40 characters" do
      string = "000#{sha1}000"

      expect(string).to_not match(subject)
    end

    let(:sha256) do
      "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
    end

    it "must match SHA256 checksums" do
      string = sha256

      expect(string).to fully_match(subject)
    end

    it "must match SHA256 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{sha256}"

      expect(string[subject]).to eq(sha256)
    end

    it "must match SHA256 checksums starting with other alpha characters" do
      string = "XXX#{sha256}"

      expect(string[subject]).to eq(sha256)
    end

    it "must match SHA256 checksums ending with other non-alpha-numeric characters" do
      string = "#{sha256} Foo"

      expect(string[subject]).to eq(sha256)
    end

    it "must match SHA256 checksums ending with other alpha characters" do
      string = "#{sha256}XXX"

      expect(string[subject]).to eq(sha256)
    end

    it "must not match a hex string longer than 64 characters" do
      string = "000#{sha256}000"

      expect(string).to_not match(subject)
    end

    let(:sha512) do
      "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"
    end

    it "must match SHA512 checksums" do
      string = sha512

      expect(string).to fully_match(subject)
    end

    it "must match SHA512 checksums starting with other non-alpha-numeric characters" do
      string = "Foo: #{sha512}"

      expect(string[subject]).to eq(sha512)
    end

    it "must match SHA512 checksums starting with other alpha characters" do
      string = "XXX#{sha512}"

      expect(string[subject]).to eq(sha512)
    end

    it "must match SHA512 checksums ending with other non-alpha-numeric characters" do
      string = "#{sha512} Foo"

      expect(string[subject]).to eq(sha512)
    end

    it "must match SHA512 checksums ending with other alpha characters" do
      string = "#{sha512}XXX"

      expect(string[subject]).to eq(sha512)
    end

    it "must not match a hex string longer than 128 characters" do
      string = "000#{sha512}000"

      expect(string).to_not match(subject)
    end

    let(:aws_access_key_id) { "AKIAIOSFODNN7EXAMPLE" }

    it "must match AWS access key IDs" do
      string = aws_access_key_id

      expect(string).to fully_match(subject)
    end

    it "must match an AWS access key ID starting with other non-alpha-numeric characters" do
      string = "Foo: #{aws_access_key_id}"

      expect(string[subject]).to eq(aws_access_key_id)
    end

    it "must match AWS access key ID checksums ending with other non-alpha-numeric characters" do
      string = "#{aws_access_key_id} Foo"

      expect(string[subject]).to eq(aws_access_key_id)
    end

    it "must not match an uppercase alpha-numeric string longer than 20 characters" do
      string = "ABC123#{aws_access_key_id}ABC123"

      expect(string).to_not match(subject)
    end

    let(:aws_secret_access_key) { "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" }

    it "must match AWS secret access keys" do
      string = aws_secret_access_key

      expect(string).to fully_match(subject)
    end

    it "must match an AWS secret access key starting with other non-alpha-numeric characters" do
      string = "Foo: #{aws_secret_access_key}"

      expect(string[subject]).to eq(aws_secret_access_key)
    end

    it "must match AWS secret access key checksums ending with other non-alpha-numeric characters" do
      string = "#{aws_secret_access_key} Foo"

      expect(string[subject]).to eq(aws_secret_access_key)
    end

    it "must not match an uppercase alpha-numeric string longer than 20 characters" do
      string = "ABC123#{aws_secret_access_key}ABC123"

      expect(string).to_not match(subject)
    end
  end

  describe "PUBLIC_KEY" do
    subject { described_class::PUBLIC_KEY }

    let(:pem) do
      <<~EOS.chomp
        -----BEGIN PUBLIC KEY-----
        MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2Ca7a99b6o+WqjH5TJeH
        ph+eBKSM2Qv2NpLkearcV4GmutK0/FgjA0JHCO+g2Fj2vNX8qojBwJPaPThfvurR
        woaBRW/pGQaf3vCWL8lxKAg3yzW+8ro1nAipC5Gg0REO0+UPuxV6IAcxck9SWYiZ
        Meoh+IZ/gUylM7z1+yXoqKdXw/hGaQMu0kEkNmKO78GSTQbn6a8y9WWRt+UKu7eq
        f67HNWh2LRUzTRasUQnGtqFvD2suYNMMtuuxvewvyWvy0BmsQfNMpavXIPI6TPlJ
        Ymqa9Vk3LHr4Mb4yNXC0o55RROI4jJUgQnXrGO2EBiUdFBYv3eHEtC6WOAO4V2jq
        BEgLbsi5k82RKYvVYREBvXRWkfkRvo/qTsUABB3NqXLeG011OHGH1GStu0yRToGp
        k+tCszh7F39+U1oAR/SOMzUVwzocdm2k3g4pV52pUXtS12Flb3bXnJprbzD9qnA7
        axN0aNh0I8rKOZnJv1XnBi06wFbSFMGQ1MJYrzdD7iVLyrDTGry2Mt2REZV/eLJZ
        +wYltRfARVjmLLni0ucyJy7c4ZD3xiVeFencyLKTa5WJEWKbaes6hiSlUDfraIxs
        9FQLEha9hQqU5I+tDUTuX81yDTHfdsneJUa5MCaHP1HuJb5DV8CsDxQC27V+UrKU
        q5HGzUly5ei6VmPzPDkKXZUCAwEAAQ==
        -----END PUBLIC KEY-----
      EOS
    end

    it "must match everything in between '-----BEGIN PUBLIC KEY-----' and '-----END PUBLIC KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN PUBLIC KEY-----' and '-----END PUBLIC KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'..','crypto','fixtures') }

  describe "DSA_PRIVATE_KEY" do
    subject { described_class::DSA_PRIVATE_KEY }

    let(:key_file) { File.join(fixtures_dir,'dsa.pem') }
    let(:pem)      { File.read(key_file).chomp }

    it "must match everything in between '-----BEGIN DSA PRIVATE KEY-----' and '-----END DSA PRIVATE KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN DSA PRIVATE KEY-----' and '-----END DSA PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN DSA PRIVATE KEY-----
        -----END DSA PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "EC_PRIVATE_KEY" do
    subject { described_class::EC_PRIVATE_KEY }

    let(:key_file) { File.join(fixtures_dir,'ec.pem') }
    let(:pem)      { File.read(key_file).chomp }

    it "must match everything in between '-----BEGIN EC PRIVATE KEY-----' and '-----END EC PRIVATE KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN EC PRIVATE KEY-----' and '-----END EC PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN EC PRIVATE KEY-----
        -----END EC PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "RSA_PRIVATE_KEY" do
    subject { described_class::RSA_PRIVATE_KEY }

    let(:key_file) { File.join(fixtures_dir,'rsa.pem') }
    let(:pem)      { File.read(key_file).chomp }

    it "must match everything in between '-----BEGIN RSA PRIVATE KEY-----' and '-----END RSA PRIVATE KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN RSA PRIVATE KEY-----' and '-----END RSA PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS
        -----BEGIN RSA PRIVATE KEY-----
        -----END RSA PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "PRIVATE_KEY" do
    subject { described_class::PRIVATE_KEY }

    let(:dsa_key_file) { File.join(fixtures_dir,'dsa.pem') }
    let(:dsa_pem)      { File.read(dsa_key_file).chomp }

    let(:ec_key_file)  { File.join(fixtures_dir,'ec.pem') }
    let(:ec_pem)       { File.read(ec_key_file).chomp }

    let(:rsa_key_file) { File.join(fixtures_dir,'rsa.pem') }
    let(:rsa_pem)      { File.read(rsa_key_file).chomp }


    it "must match everything in between '-----BEGIN DSA PRIVATE KEY-----' and '-----END DSA PRIVATE KEY-----'" do
      expect(dsa_pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN DSA PRIVATE KEY-----' and '-----END DSA PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN DSA PRIVATE KEY-----
        -----END DSA PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end

    it "must match everything in between '-----BEGIN EC PRIVATE KEY-----' and '-----END EC PRIVATE KEY-----'" do
      expect(ec_pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN EC PRIVATE KEY-----' and '-----END EC PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN EC PRIVATE KEY-----
        -----END EC PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end

    it "must match everything in between '-----BEGIN RSA PRIVATE KEY-----' and '-----END RSA PRIVATE KEY-----'" do
      expect(rsa_pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN RSA PRIVATE KEY-----' and '-----END RSA PRIVATE KEY-----' blocks" do
      empty_pem = <<~EOS.chomp
        -----BEGIN RSA PRIVATE KEY-----
        -----END RSA PRIVATE KEY-----
      EOS

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "WORD" do
    let(:word) { 'dog' }

    subject { described_class::WORD }

    it "must not match single letters" do
      expect('A').to_not match(subject)
    end

    it "must not match numeric letters" do
      expect(subject.match("123#{word}123")[0]).to eq(word)
    end

    it "must not include ending periods" do
      expect(subject.match("#{word}.")[0]).to eq(word)
    end

    it "must not include leading punctuation" do
      expect(subject.match("'#{word}")[0]).to eq(word)
    end

    it "must not include tailing punctuation" do
      expect(subject.match("#{word}'")[0]).to eq(word)
    end

    it "must include punctuation in the middle of the word" do
      name = "O'Brian"

      expect(name).to fully_match(subject)
    end
  end

  describe "MAC_ADDR" do
    subject { described_class::MAC_ADDR }

    it "must match six hexadecimal bytes" do
      mac_addr = '12:34:56:78:9a:bc'

      expect(mac_addr).to fully_match(subject)
    end
  end

  describe "IPV4_ADDR" do
    subject { described_class::IPV4_ADDR }

    it "must match valid addresses" do
      ip = '127.0.0.1'

      expect(ip).to fully_match(subject)
    end

    it "must match the Any address" do
      ip = '0.0.0.0'

      expect(ip).to fully_match(subject)
    end

    it "must match the broadcast address" do
      ip = '255.255.255.255'

      expect(ip).to fully_match(subject)
    end

    it "must match addresses with netmasks" do
      ip = '10.1.1.1/24'

      expect(ip).to fully_match(subject)
    end

    it "must not match addresses with octets > 255" do
      ip = '10.1.256.1'

      expect(ip).to_not match(subject)
    end

    it "must not match addresses with more than three digits per octet" do
      ip = '10.1111.1.1'

      expect(ip).to_not match(subject)
    end
  end

  describe "IPV6_ADDR" do
    subject { described_class::IPV6_ADDR }

    it "must match valid IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(ip).to fully_match(subject)
    end

    it "must match IPv6 addresses with netmasks" do
      ip = '2001:db8:1234::/48'

      expect(ip).to fully_match(subject)
    end

    it "must match truncated IPv6 addresses" do
      ip = '2001:db8:85a3::8a2e:370:7334'

      expect(ip).to fully_match(subject)
    end

    it "must match IPv4-mapped IPv6 addresses" do
      ip = '::ffff:192.0.2.128'

      expect(ip).to fully_match(subject)
    end
  end

  describe "IP_ADDR" do
    subject { described_class::IP_ADDR }

    it "must match IPv4 addresses" do
      ip = '10.1.1.1'

      expect(ip).to fully_match(subject)
    end

    it "must match IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(ip).to fully_match(subject)
    end
  end

  describe "DOMAIN" do
    subject { described_class::DOMAIN }

    it "must match valid domain names" do
      domain = 'example.com'

      expect(domain).to fully_match(subject)
    end

    it "must not match hostnames without a TLD" do
      expect('foo').to_not match(subject)
    end

    it "must match domains within punctuation" do
      domain = 'example.com'
      html   = "<a href=\"https://#{domain}/foo>link</a>"

      expect(html.match(subject)[0]).to eq(domain)
    end

    it "must match domains within hostnames" do
      domain   = 'example.com'
      hostname = "www.#{domain}"

      expect(hostname.match(subject)[0]).to eq(domain)
    end

    it "must not match domains starting with a '_' character" do
      expect("_foo.com").to_not match(subject)
    end

    it "must not match domains ending with a '_' character" do
      expect("foo_.com").to_not match(subject)
    end

    it "must not match domains containing '_' characters" do
      expect("foo_bar.com").to_not match(subject)
    end

    it "must not match domains starting with a '-' character" do
      expect("-foo.com").to_not match(subject)
    end

    it "must not match domains ending with a '-' character" do
      expect("foo-.com").to_not match(subject)
    end

    it "must not match domains with unknown TLDs" do
      expect('foo.zzz').to_not match(subject)
    end

    it "must not partially match a string which contains a TLD name" do
      expect('foo.commmmm').to_not match(subject)
    end

    it "must not match domains with TLDs that begin with a valid TLD" do
      expect("foo.comzzz").to_not match(subject)
    end
  end

  describe "HOST_NAME" do
    subject { described_class::HOST_NAME }

    it "must match valid hostnames" do
      hostname = 'www.example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must match sub-sub-domains" do
      hostname = 'foo.bar.example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must also match valid domain names" do
      hostname = 'example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must match hostnames starting with a '_' character" do
      hostname = '_spf.example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must match hostnames within punctuation" do
      hostname = 'www.example.com'
      html     = "<a href=\"https://#{hostname}/foo>link</a>"

      expect(html.match(subject)[0]).to eq(hostname)
    end

    it "must not match hostnames starting with a '.' character" do
      expect('.www.example.com').to_not match(subject)
    end

    it "must not match hostnames with labels longer than 63 characters" do
      label    = 'a' * 64
      hostname = "#{label}.example.com"

      expect(hostname).to_not match(subject)
    end

    it "must not match hostnames without a TLD" do
      expect('www.has-no-tld').to_not match(subject)
    end

    it "must not match hostnames with unknown TLDs" do
      expect('www.foo.zzz').to_not match(subject)
    end

    it "must not match hostnames with TLDs that begin with a valid TLD" do
      expect("www.foo.comzzz").to_not match(subject)
    end
  end

  describe "URI" do
    subject { described_class::URI }

    it "must match http://example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match https://example.com" do
      expect("https://example.com").to fully_match(subject)
    end

    it "must match http://www.example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match http://127.0.0.1" do
      expect("http://127.0.0.1").to fully_match(subject)
    end

    it "must match http://127.0.0.1:8000" do
      expect("http://127.0.0.1:8000").to fully_match(subject)
    end

    it "must match http://[::1]" do
      expect("http://[::1]").to fully_match(subject)
    end

    it "must match http://[::1]:8000" do
      expect("http://[::1]:8000").to fully_match(subject)
    end

    it "must match http://example.com:8000" do
      expect("http://example.com:8000").to fully_match(subject)
    end

    it "must match http://user@example.com" do
      expect("http://user@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com" do
      expect("http://user:password@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com:8000" do
      expect("http://user:password@example.com:8000").to fully_match(subject)
    end

    it "must match http://example.com/" do
      expect("http://example.com/").to fully_match(subject)
    end

    it "must match http://example.com:8000/" do
      expect("http://example.com:8000/").to fully_match(subject)
    end

    it "must match http://example.com/foo" do
      expect("http://example.com/foo").to fully_match(subject)
    end

    it "must match http://example.com/foo/bar" do
      expect("http://example.com/foo/bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/./bar" do
      expect("http://example.com/foo/./bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/../bar" do
      expect("http://example.com/foo/../bar").to fully_match(subject)
    end

    it "must match http://example.com/foo%20bar" do
      expect("http://example.com/foo%20bar").to fully_match(subject)
    end

    it "must match http://example.com?id=1" do
      expect("http://example.com?id=1").to fully_match(subject)
    end

    it "must match http://example.com/?id=1" do
      expect("http://example.com/?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1" do
      expect("http://example.com/foo?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=%20" do
      expect("http://example.com/foo?id=%20").to fully_match(subject)
    end

    it "must match http://example.com#fragment" do
      expect("http://example.com#fragment").to fully_match(subject)
    end

    it "must match http://example.com/#fragment" do
      expect("http://example.com/#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo#fragment" do
      expect("http://example.com/foo#fragment").to fully_match(subject)
    end

    it "must match http://example.com?id=1#fragment" do
      expect("http://example.com?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/?id=1#fragment" do
      expect("http://example.com/?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1#fragment" do
      expect("http://example.com/foo?id=1#fragment").to fully_match(subject)
    end

    it "must match ssh://user@host.example.com" do
      expect("ssh://user@host.example.com").to fully_match(subject)
    end

    it "must match ldap://ds.example.com:389" do
      expect("ldap://ds.example.com:389").to fully_match(subject)
    end

    it "must match foo://host" do
      expect("foo://host").to fully_match(subject)
    end

    it "must match foo:/path" do
      expect("foo:/path").to fully_match(subject)
    end

    it "must match foo:" do
      expect("foo:").to fully_match(subject)
    end
  end

  describe "URL" do
    subject { described_class::URL }

    it "must match http://example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match https://example.com" do
      expect("https://example.com").to fully_match(subject)
    end

    it "must match http://www.example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match http://127.0.0.1" do
      expect("http://127.0.0.1").to fully_match(subject)
    end

    it "must match http://127.0.0.1:8000" do
      expect("http://127.0.0.1:8000").to fully_match(subject)
    end

    it "must match http://[::1]" do
      expect("http://[::1]").to fully_match(subject)
    end

    it "must match http://[::1]:8000" do
      expect("http://[::1]:8000").to fully_match(subject)
    end

    it "must match http://example.com:8000" do
      expect("http://example.com:8000").to fully_match(subject)
    end

    it "must match http://user@example.com" do
      expect("http://user@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com" do
      expect("http://user:password@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com:8000" do
      expect("http://user:password@example.com:8000").to fully_match(subject)
    end

    it "must match http://example.com/" do
      expect("http://example.com/").to fully_match(subject)
    end

    it "must match http://example.com:8000/" do
      expect("http://example.com:8000/").to fully_match(subject)
    end

    it "must match http://example.com/foo" do
      expect("http://example.com/foo").to fully_match(subject)
    end

    it "must match http://example.com/foo/bar" do
      expect("http://example.com/foo/bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/./bar" do
      expect("http://example.com/foo/./bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/../bar" do
      expect("http://example.com/foo/../bar").to fully_match(subject)
    end

    it "must match http://example.com/foo%20bar" do
      expect("http://example.com/foo%20bar").to fully_match(subject)
    end

    it "must match http://example.com?id=1" do
      expect("http://example.com?id=1").to fully_match(subject)
    end

    it "must match http://example.com/?id=1" do
      expect("http://example.com/?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1" do
      expect("http://example.com/foo?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=%20" do
      expect("http://example.com/foo?id=%20").to fully_match(subject)
    end

    it "must match http://example.com#fragment" do
      expect("http://example.com#fragment").to fully_match(subject)
    end

    it "must match http://example.com/#fragment" do
      expect("http://example.com/#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo#fragment" do
      expect("http://example.com/foo#fragment").to fully_match(subject)
    end

    it "must match http://example.com?id=1#fragment" do
      expect("http://example.com?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/?id=1#fragment" do
      expect("http://example.com/?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1#fragment" do
      expect("http://example.com/foo?id=1#fragment").to fully_match(subject)
    end

    it "must match ssh://user@host.example.com" do
      expect("ssh://user@host.example.com").to fully_match(subject)
    end

    it "must match ldap://ds.example.com:389" do
      expect("ldap://ds.example.com:389").to fully_match(subject)
    end

    it "must not match http://" do
      expect("http://").to_not match(subject)
    end
  end

  describe "USER_NAME" do
    subject { described_class::USER_NAME }

    it "must match valid user-names" do
      username = 'alice1234'

      expect(username).to fully_match(subject)
    end

    it "must match user-names containing '_' characters" do
      username = 'alice_1234'

      expect(username).to fully_match(subject)
    end

    it "must match user-names containing '.' characters" do
      username = 'alice.1234'

      expect(username).to fully_match(subject)
    end

    it "must not match user-names beginning with numbers" do
      expect(subject.match('1234bob')[0]).to eq('bob')
    end

    it "must not match user-names containing spaces" do
      expect(subject.match('alice eve')[0]).to eq('alice')
    end

    it "must not match user-names containing other symbols" do
      expect(subject.match('alice^eve')[0]).to eq('alice')
    end
  end

  describe "EMAIL_ADDRESS" do
    subject { described_class::EMAIL_ADDRESS }

    it "must match valid email addresses" do
      email = 'alice@example.com'

      expect(email).to fully_match(subject)
    end
  end

  describe "OBFUSCATED_EMAIL_ADDRESS" do
    subject { described_class::OBFUSCATED_EMAIL_ADDRESS }

    it "must match valid email addresses" do
      email = 'alice@example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' AT '" do
      email = 'alice AT example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' at '" do
      email = 'alice at example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '[AT]'" do
      email = 'alice[AT]example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' [AT] '" do
      email = 'alice [AT] example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '[at]'" do
      email = 'alice[at]example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' [at] '" do
      email = 'alice [at] example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '<AT>'" do
      email = 'alice<AT>example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' <AT> '" do
      email = 'alice <AT> example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '<at>'" do
      email = 'alice<at>example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' <at> '" do
      email = 'alice <at> example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '{AT}'" do
      email = 'alice{AT}example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' {AT} '" do
      email = 'alice {AT} example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '{at}'" do
      email = 'alice{at}example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' {at} '" do
      email = 'alice {at} example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '(AT)'" do
      email = 'alice(AT)example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' (AT) '" do
      email = 'alice (AT) example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by '(at)'" do
      email = 'alice(at)example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where the '@' character have been replaced by ' (at) '" do
      email = 'alice (at) example.com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' DOT '" do
      email = 'foo DOT bar@example DOT com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' dot '" do
      email = 'foo dot bar@example dot com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '[DOT]'" do
      email = 'foo[DOT]bar@example[DOT]com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' [DOT] '" do
      email = 'foo [DOT] bar@example [DOT] com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '[dot]'" do
      email = 'foo[dot]bar@example[dot]com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' [dot] '" do
      email = 'foo [dot] bar@example [dot] com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '<DOT>'" do
      email = 'foo<DOT>bar@example<DOT>com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' <DOT> '" do
      email = 'foo <DOT> bar@example <DOT> com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '<dot>'" do
      email = 'foo<dot>bar@example<dot>com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' <dot> '" do
      email = 'foo <dot> bar@example <dot> com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '{DOT}'" do
      email = 'foo{DOT}bar@example{DOT}com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' {DOT} '" do
      email = 'foo {DOT} bar@example {DOT} com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '{dot}'" do
      email = 'foo{dot}bar@example{dot}com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' {dot} '" do
      email = 'foo {dot} bar@example {dot} com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '(DOT)'" do
      email = 'foo(DOT)bar@example(DOT)com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' (DOT) '" do
      email = 'foo (DOT) bar@example (DOT) com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by '(dot)'" do
      email = 'foo(dot)bar@example(dot)com'

      expect(email).to fully_match(subject)
    end

    it "must match an email addresses where '.' characters have been replaced by ' (dot) '" do
      email = 'foo (dot) bar@example (dot) com'

      expect(email).to fully_match(subject)
    end
  end

  describe "PHONE_NUMBER" do
    subject { described_class::PHONE_NUMBER }

    it "must match 111-2222" do
      number = '111-2222'

      expect(number).to fully_match(subject)
    end

    it "must match 111-2222x9" do
      number = '111-2222x9'

      expect(number).to fully_match(subject)
    end

    it "must match 800-111-2222" do
      number = '800-111-2222'

      expect(number).to fully_match(subject)
    end

    it "must match 1-800-111-2222" do
      number = '1-800-111-2222'

      expect(number).to fully_match(subject)
    end
  end

  describe "SSN" do
    subject { described_class::SSN }

    it "must match NNN-NN-NNNN" do
      ssn = "111-22-3333"

      expect(ssn).to fully_match(subject)
    end

    it "must not match strings starting with more than three digits" do
      bad_ssn = "111111111-22-3333"

      expect(bad_ssn).to_not match(subject)
    end

    it "must not match strings ending with more than four digits" do
      bad_ssn = "111-22-3333333333"

      expect(bad_ssn).to_not match(subject)
    end
  end

  describe "AMEX_CC" do
    subject { described_class::AMEX_CC }

    it "must match 34XXXXXXXXXXXXX" do
      cc = "341111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must match 37XXXXXXXXXXXXX" do
      cc = "371111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must not match strings not starting with a 34 or 37" do
      bad_ccs = %w[
        301111111111111
        311111111111111
        321111111111111
        331111111111111
        351111111111111
        361111111111111
        381111111111111
        391111111111111
      ]

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings not starting with a 3" do
      bad_ccs = %w[
        011111111111111
        111111111111111
        211111111111111
        411111111111111
        511111111111111
        611111111111111
        711111111111111
        811111111111111
        911111111111111
      ]

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings less than 15 digits" do
      cc = "37111111111111"

      expect(subject.match(cc)).to be(nil)
    end

    it "must not match strings longer than 15 digits" do
      cc = "3711111111111111"

      expect(subject.match(cc)).to be(nil)
    end
  end

  describe "DISCOVER_CC" do
    subject { described_class::DISCOVER_CC }

    it "must match strings between 654XXXXXXXXXXXXX - 659XXXXXXXXXXXXX" do
      ccs = (654..659).map { |prefix| "#{prefix}1111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 644XXXXXXXXXXXXX - 649XXXXXXXXXXXXX" do
      ccs = (644..649).map { |prefix| "#{prefix}1111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 622126XXXXXXXXXX - 622129XXXXXXXXXX" do
      ccs = (622126..622129).map { |prefix| "#{prefix}1111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 622130XXXXXXXXXX - 622199XXXXXXXXXX" do
      ccs = (622130..622199).map { |prefix| "#{prefix}1111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 622200XXXXXXXXXX - 622899XXXXXXXXXX" do
      ccs = (622200..622899).map { |prefix| "#{prefix}1111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 622900XXXXXXXXXX - 622919XXXXXXXXXX" do
      ccs = (622900..622919).map { |prefix| "#{prefix}1111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 622920XXXXXXXXXX - 622925XXXXXXXXXX" do
      ccs = (622920..622925).map { |prefix| "#{prefix}1111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must not match strings without the 622*, 64*, 65* prefixes" do
      bad_ccs = %w[
        601111111111111111
        611111111111111111
        620111111111111111
        623111111111111111
        624111111111111111
        625111111111111111
        626111111111111111
        627111111111111111
        628111111111111111
        629111111111111111
        631111111111111111
        661111111111111111
        671111111111111111
        681111111111111111
        691111111111111111
      ]

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings without the 6* prefix" do
      bad_ccs = %w[
        011111111111111111
        111111111111111111
        211111111111111111
        311111111111111111
        411111111111111111
        511111111111111111
        711111111111111111
        811111111111111111
        911111111111111111
      ]

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings with less than 16 digits" do
      bad_cc = "654111111111111"

      expect(subject.match(bad_cc)).to be(nil)
    end

    it "must not match strings with more than 16 digits" do
      bad_cc = "65411111111111111"

      expect(subject.match(bad_cc)).to be(nil)
    end
  end

  describe "MASTERCARD_CC" do
    subject { described_class::MASTERCARD_CC }

    it "must match strings between 51XXXXXXXXXXXXXX - 55XXXXXXXXXXXXXX" do
      ccs = (51..55).map { |prefix| "#{prefix}11111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 2221XXXXXXXXXXXX - 2229XXXXXXXXXXXX" do
      ccs = (2221..2229).map { |prefix| "#{prefix}111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 223XXXXXXXXXXXXX - 229XXXXXXXXXXXXX" do
      ccs = (223..229).map { |prefix| "#{prefix}1111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 23XXXXXXXXXXXXXX - 26XXXXXXXXXXXXXX" do
      ccs = (23..26).map { |prefix| "#{prefix}11111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings between 270XXXXXXXXXXXX - 271XXXXXXXXXXXX" do
      ccs = (270..271).map { |prefix| "#{prefix}1111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must match strings with the 2720XXXXXXXXXXXX prefix" do
      cc = "2720111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must not match strings with less than 16 digits" do
      bad_cc = "511111111111111"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings with more than 16 digits" do
      bad_cc = "51111111111111111"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings with the 50XXXXXXXXXXXX prefix" do
      bad_cc = "50111111111111"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings between 0XXXXXXXXXXXXX - 2XXXXXXXXXXXXX" do
      bad_ccs = (0..2).map { |prefix| "#{prefix}111111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings between 272XXXXXXXXXXX - 509XXXXXXXXXXX" do
      bad_ccs = (272..509).map { |prefix| "#{prefix}1111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings between 2000XXXXXXXXXX - 2220XXXXXXXXXX" do
      bad_ccs = (2000..2200).map { |prefix| "#{prefix}111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings between 56XXXXXXXXXXXX - 59XXXXXXXXXXXX" do
      bad_ccs = (56..59).map { |prefix| "#{prefix}111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings between 6XXXXXXXXXXXXX - 9XXXXXXXXXXXXX" do
      bad_ccs = (6..9).map { |prefix| "#{prefix}1111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end
  end

  describe "VISA_CC" do
    subject { described_class::VISA_CC }

    it "must match strings with the 4XXXXXXXXXXXX prefix" do
      cc = "4111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must also match 4XXXXXXXXXXXX strings with an extra XXX suffix" do
      cc = "4111111111111222"

      expect(cc).to fully_match(subject)
    end

    it "must not match strings with less than 13 digits" do
      bad_cc = "411111111111"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings with more than 16 digits" do
      bad_cc = "41111111111112223"

      expect(bad_cc).to_not match(subject)
    end
  end

  describe "VISA_MASTERCARD_CC" do
    subject { described_class::VISA_MASTERCARD_CC }

    it "must match strings with the 4XXXXXXXXXXXX prefix" do
      cc = "4111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must also match 4XXXXXXXXXXXX strings with an extra XXX suffix" do
      cc = "4111111111111012"

      expect(cc).to fully_match(subject)
    end

    it "must match strings between 51XXXXXXXXXXXXXX - 55XXXXXXXXXXXXXX" do
      ccs = (51..55).map { |prefix| "#{prefix}11111111111111" }

      expect(ccs).to all(match(subject))
    end

    it "must not match strings starting with 4 but have less than 13 digits" do
      bad_cc = "411111111111"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings starting with 4 but have less than 17 digits" do
      bad_cc = "41111111111112223"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings starting with 50*" do
      bad_cc = "5011111111111111"

      expect(bad_cc).to_not match(subject)
    end

    it "must not match strings between 56XXXXXXXXXXXXXX - 99XXXXXXXXXXXXXX" do
      bad_ccs = (56..99).map { |prefix| "#{prefix}11111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings starting with 51 - 56 but have less than 16 digits" do
      bad_ccs = (51..55).map { |prefix| "#{prefix}1111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end

    it "must not match strings starting with 51 - 56 but have more than 16 digits" do
      bad_ccs = (51..55).map { |prefix| "#{prefix}111111111111111" }

      expect(bad_ccs.grep(subject)).to be_empty
    end
  end

  describe "CC" do
    subject { described_class::CC }

    it "must match a VISA CC number" do
      cc = "4111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must match a VISA/Mastercard CC number" do
      cc = "5511111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must match a Mastercard CC number" do
      cc = "2229111111111111"

      expect(cc).to fully_match(subject)
    end

    it "must match a Discover Card CC number" do
      cc = "6229201111111111"

      expect(cc).to fully_match(subject)
    end

    it "must match a AMEX CC number" do
      cc = "371111111111111"

      expect(cc).to fully_match(subject)
    end
  end

  describe "IDENTIFIER" do
    subject { described_class::IDENTIFIER }

    it "must match Strings beginning with a '_' character" do
      identifier = '_foo'

      expect(identifier).to fully_match(subject)
    end

    it "must match Strings ending with a '_' character" do
      identifier = 'foo_'

      expect(identifier).to fully_match(subject)
    end

    it "must not match Strings beginning with numberic characters" do
      expect(subject.match('1234foo')[0]).to eq('foo')
    end

    it "must not match Strings not containing any alpha characters" do
      identifier = '_1234_'

      expect(identifier).to_not match(subject)
    end
  end

  describe "VARIABLE_NAME" do
    subject { described_class::VARIABLE_NAME }

    let(:name) { "foo" }

    it "must match identifiers followed by a '=' character" do
      string = "#{name}=1"

      expect(subject.match(string)[0]).to eq(name)
    end

    it "must match identifiers followed by a space then a '=' character" do
      string = "#{name} = 1"

      expect(subject.match(string)[0]).to eq(name)
    end

    it "must not match identifiers not followed by a '=' character" do
      string = name

      expect(string).to_not match(subject)
    end
  end

  describe "VARIABLE_ASSIGNMENT" do
    subject { described_class::VARIABLE_ASSIGNMENT }

    it "must match identifiers followed by a '=' character" do
      string = "foo=1"

      expect(string).to fully_match(subject)
    end

    it "must match identifiers followed by a space then a '=' character" do
      string = "foo = 1"

      expect(string).to fully_match(subject)
    end

    it "must not match identifiers not followed by a '=' character" do
      string = "foo"

      expect(string).to_not match(subject)
    end
  end

  describe "FUNCTION_NAME" do
    subject { described_class::FUNCTION_NAME }

    it "must match identifiers that are followed by an opening parenthesis" do
      name   = "foo"
      string = "#{name}("

      expect(subject.match(string)[0]).to eq(name)
    end

    it "must not match an identifier name without parenthesis following it" do
      string = "foo"

      expect(string).to_not match(subject)
    end
  end

  describe "DOUBLE_QUOTED_STRING" do
    subject { described_class::DOUBLE_QUOTED_STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(string).to_not match(subject)
    end

    it "must match double-quoted text" do
      string = "\"foo\""

      expect(string).to fully_match(subject)
    end

    it "must match double-quoted text containing backslash-escaped chars" do
      string = "\"foo\\\"bar\\\"baz\\0\""

      expect(string).to fully_match(subject)
    end
  end

  describe "SINGLE_QUOTED_STRING" do
    subject { described_class::SINGLE_QUOTED_STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(string).to_not match(subject)
    end

    it "must match single-quoted text" do
      string = "'foo'"

      expect(string).to fully_match(subject)
    end

    it "must match single-quoted text containing backslash-escaped chars" do
      string = "'foo\\bar\\''"

      expect(string).to fully_match(subject)
    end
  end

  describe "STRING" do
    subject { described_class::STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(string).to_not match(subject)
    end

    it "must match double-quoted text" do
      string = "\"foo\""

      expect(string).to fully_match(subject)
    end

    it "must match double-quoted text containing backslash-escaped chars" do
      string = "\"foo\\\"bar\\\"baz\\0\""

      expect(string).to fully_match(subject)
    end

    it "must match single-quoted text" do
      string = "'foo'"

      expect(string).to fully_match(subject)
    end

    it "must match single-quoted text containing backslash-escaped chars" do
      string = "'foo\\bar\\''"

      expect(string).to fully_match(subject)
    end
  end

  describe "BASE64" do
    subject { described_class::BASE64 }

    it "must not match alphabetic strings less then four characters long" do
      string = "YWE"

      expect(string).to_not match(subject)
    end

    it "must match alphabetic strings padded with '=' characters" do
      string = "YQ=="

      expect(string).to fully_match(subject)
    end

    it "must match alphabetic strings with four characters exactly" do
      string = "YWFh"

      expect(string).to fully_match(subject)
    end

    it "must match alphabetic strings longer than four characters but padded with '=' characters" do
      string = "YWFhYQ=="

      expect(string).to fully_match(subject)
    end

    it "must match alphabetic strings that include newline characters" do
      string = "QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB\nQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB\nQUFBQUFBQUFBQQ==\n"

      expect(string).to fully_match(subject)
    end
  end

  describe "COMMENT" do
    subject { described_class::COMMENT }

    it "must match a single-line // comment" do
      string = "// comment"

      expect(string).to fully_match(subject)
    end

    it "must match a single-line // comment that does end with a new-line" do
      string = "// comment\n"

      expect(string).to fully_match(subject)
    end

    it "must match multiple // comments in a row" do
      string = <<~TEXT.chomp
        // comment 1
        // comment 2
        // comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match multiple // comments in a row, that ends with a new-line" do
      string = <<~TEXT
        // comment 1
        // comment 2
        // comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match a single-line // comment within a string" do
      string = <<~CODE
      foo
      // comment
      bar
      CODE

      expect(string).to match(subject)
    end

    it "must match a single-line # comment" do
      string = "# comment"

      expect(string).to fully_match(subject)
    end

    it "must match a single-line # comment that ends with a new-line" do
      string = "# comment\n"

      expect(string).to fully_match(subject)
    end

    it "must match multiple # comments in a row" do
      string = <<~TEXT.chomp
        # comment 1
        # comment 2
        # comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match multiple # comments in a row, that ends with a new-line" do
      string = <<~TEXT
        # comment 1
        # comment 2
        # comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match a single-line # comment within a string" do
      string = <<~CODE
      foo
      # comment
      bar
      CODE

      expect(string).to match(subject)
    end

    it "must match a single-line /* ... */ comment" do
      string = "/* comment here */"

      expect(string).to fully_match(subject)
    end

    it "must match a single-line /* ... */ comment that ends with a new-line" do
      string = "/* comment here */\n"

      expect(string).to match(subject)
    end

    it "must match a multi-line /* ... */ comment" do
      string = <<~TEXT.chomp
      /*
       * foo
       * bar
       * baz
       */
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match a multi-line /* ... */ comment that ends with a new-line" do
      string = <<~TEXT
      /*
       * foo
       * bar
       * baz
       */
      TEXT

      expect(string).to match(subject)
    end
  end

  describe "FILE_EXT" do
    subject { described_class::FILE_EXT }

    it "must match the '.' separator character" do
      ext = '.txt'

      expect(ext).to fully_match(subject)
    end

    it "must not allow '_' characters" do
      ext = '.foo_bar'

      expect(ext.match(subject)[0]).to eq('.foo')
    end

    it "must not allow '-' characters" do
      ext = '.foo-bar'

      expect(ext.match(subject)[0]).to eq('.foo')
    end
  end

  describe "FILE_NAME" do
    subject { described_class::FILE_NAME }

    it "must match the filename and extension" do
      filename = 'foo_bar.txt'

      expect(filename).to fully_match(subject)
    end

    it "must match '\\' escapped characters" do
      filename = 'foo\\ bar.txt'

      expect(filename).to fully_match(subject)
    end

    it "must match file names without extensions" do
      filename = 'foo_bar'

      expect(filename).to fully_match(subject)
    end
  end

  describe "DIR_NAME" do
    subject { described_class::DIR_NAME }

    it "must match directory names" do
      dir = 'foo_bar'

      expect(dir).to fully_match(subject)
    end

    it "must match '.'" do
      dir = '.'

      expect(dir).to fully_match(subject)
    end

    it "must match '..'" do
      dir = '..'

      expect(dir).to fully_match(subject)
    end
  end

  describe "RELATIVE_UNIX_PATH" do
    subject { described_class::RELATIVE_UNIX_PATH }

    it "must match multiple directories" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "ABSOLUTE_UNIX_PATH" do
    subject { described_class::ABSOLUTE_UNIX_PATH }

    it "must match absolute paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end

    it "must match trailing '/' characters" do
      path = '/foo/bar/baz/'

      expect(path).to fully_match(subject)
    end

    it "must not match relative directories" do
      path = '/foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq('/foo/')
    end
  end

  describe "UNIX_PATH" do
    subject { described_class::UNIX_PATH }

    it "must match relative paths" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "RELATIVE_WINDOWS_PATH" do
    subject { described_class::RELATIVE_WINDOWS_PATH }

    it "must match multiple directories" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "ABSOLUTE_WINDOWS_PATH" do
    subject { described_class::ABSOLUTE_WINDOWS_PATH }

    it "must match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end

    it "must match trailing '/' characters" do
      path = 'C:\\foo\\bar\\baz\\'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must not match relative directories" do
      path = 'C:\\foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq('C:\\foo\\')
    end
  end

  describe "WINDOWS_PATH" do
    subject { described_class::WINDOWS_PATH }

    it "must match relative paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "RELATIVE_PATH" do
    subject { described_class::RELATIVE_PATH }

    it "must match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end

    it "must match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "ABSOLUTE_PATH" do
    subject { described_class::ABSOLUTE_PATH }

    it "must match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "PATH" do
    subject { described_class::PATH }

    it "must match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end

    it "must match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end
  end
end
