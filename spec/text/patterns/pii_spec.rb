require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/pii'

describe Ronin::Support::Text::Patterns do
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
end
