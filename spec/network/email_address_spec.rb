require 'spec_helper'
require 'ronin/support/network/email_address'

describe Ronin::Support::Network::EmailAddress do
  let(:name)    { "John Smith"  }
  let(:mailbox) { "john.smith"  }
  let(:tag)     { 'spam'        }
  let(:routing) { %w[host1.com host2.com] }
  let(:domain)  { "example.com" }
  let(:address) { '1.2.3.4'     }

  subject { described_class.new(mailbox: mailbox, domain: domain) }

  describe "#initialize" do
    it "must set #mailbox" do
      expect(subject.mailbox).to eq(mailbox)
    end

    context "when the tag: keyword is given" do
      subject do
        described_class.new(
          mailbox: mailbox,
          tag: tag,
          domain: domain
        )
      end

      it "must set #tag" do
        expect(subject.tag).to eq(tag)
      end
    end

    context "when the routing: keyword is given" do
      subject do
        described_class.new(
          mailbox: mailbox,
          routing: routing,
          domain:  domain
        )
      end

      it "must set #routing" do
        expect(subject.routing).to eq(routing)
      end
    end

    context "when the domain: keyword is given" do
      it "must set #domain" do
        expect(subject.domain).to eq(domain)
      end
    end

    context "when the address: keyword is given" do
      subject { described_class.new(mailbox: mailbox, address: address) }

      it "must set #address" do
        expect(subject.address).to eq(address)
      end
    end

    context "when neither domain: nor address: are given" do
      it do
        expect {
          described_class.new(mailbox: mailbox)
        }.to raise_error(ArgumentError,"must specify domain: or address: keyword arguments")
      end
    end

    context "when both domain: and address: are given" do
      it do
        expect {
          described_class.new(
            mailbox: mailbox,
            domain:  domain,
            address: address
          )
        }.to raise_error(ArgumentError,"must specify domain: or address: keyword arguments")
      end
    end
  end

  describe ".parse" do
    context "when given 'mailbox@domain.com'" do
      subject { described_class.parse("#{mailbox}@#{domain}") }

      it "must parse the mailbox part" do
        expect(subject.mailbox).to eq(mailbox)
      end

      it "must parse the domain part" do
        expect(subject.domain).to eq(domain)
      end
    end

    context "when given 'Name <mailbox@domain.com>'" do
      subject { described_class.parse("#{name} <#{mailbox}@#{domain}>") }

      it "must parse the name part" do
        expect(subject.name).to eq(name)
      end

      it "must parse the mailbox part" do
        expect(subject.mailbox).to eq(mailbox)
      end

      it "must parse the domain part" do
        expect(subject.domain).to eq(domain)
      end
    end

    context "when given 'mailbox+tag@domain.com'" do
      subject { described_class.parse("#{mailbox}+#{tag}@#{domain}") }

      it "must parse the mailbox part" do
        expect(subject.mailbox).to eq(mailbox)
      end

      it "must parse the tag part" do
        expect(subject.tag).to eq(tag)
      end

      it "must parse the domain part" do
        expect(subject.domain).to eq(domain)
      end
    end

    context "when given 'mailbox%host1%host2%...@domain.com'" do
      let(:host2) { "host1.com" }
      let(:host3) { "host2.com" }

      subject { described_class.parse("#{mailbox}%#{host3}%#{host2}@#{domain}") }

      it "must parse the mailbox part" do
        expect(subject.mailbox).to eq(mailbox)
      end

      it "must parse the additional routing hosts" do
        expect(subject.routing).to eq([host3, host2])
      end

      it "must parse the domain part" do
        expect(subject.domain).to eq(domain)
      end
    end

    context "when given 'mailbox@[address]'" do
      let(:address) { '1.2.3.4' }

      subject { described_class.parse("#{mailbox}@[#{address}]") }

      it "must parse the mailbox part" do
        expect(subject.mailbox).to eq(mailbox)
      end

      it "must set #domain to nil" do
        expect(subject.domain).to be(nil)
      end

      it "must parse the embedded IP address" do
        expect(subject.address).to eq(address)
      end
    end

    context "when given '<mailbox@domain.com>'" do
      let(:string) { "<#{mailbox}@#{domain}>" }

      it do
        expect {
          described_class.parse(string)
        }.to raise_error(Ronin::Support::Network::InvalidEmailAddress,"invalid email address: #{string.inspect}")
      end
    end

    context "when the string does not contain a '@' character" do
      let(:string) { mailbox }

      it do
        expect {
          described_class.parse(string)
        }.to raise_error(Ronin::Support::Network::InvalidEmailAddress,"invalid email address: #{string.inspect}")
      end
    end
  end

  describe ".deobfuscat" do
    subject { described_class }

    context "when given 'mailbox @ domain.com'" do
      let(:string) { "mailbox @ example.com" }

      it "must replace ' @ ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox AT domain.com'" do
      let(:string) { "mailbox AT example.com" }

      it "must replace ' AT ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox at domain.com'" do
      let(:string) { "mailbox at example.com" }

      it "must replace ' at ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox[AT]domain.com'" do
      let(:string) { "mailbox[AT]example.com" }

      it "must replace '[AT]' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox [AT] domain.com'" do
      let(:string) { "mailbox [AT] example.com" }

      it "must replace ' [AT] ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox[at]domain.com'" do
      let(:string) { "mailbox[at]example.com" }

      it "must replace '[at]' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox [at] domain.com'" do
      let(:string) { "mailbox [at] example.com" }

      it "must replace ' [at] ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox<AT>domain.com'" do
      let(:string) { "mailbox<AT>example.com" }

      it "must replace '<AT>' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox <AT> domain.com'" do
      let(:string) { "mailbox <AT> example.com" }

      it "must replace ' <AT> ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox<at>domain.com'" do
      let(:string) { "mailbox<at>example.com" }

      it "must replace '<at>' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox <at> domain.com'" do
      let(:string) { "mailbox <at> example.com" }

      it "must replace ' <at> ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox{AT}domain.com'" do
      let(:string) { "mailbox{AT}example.com" }

      it "must replace '{AT}' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox {AT} domain.com'" do
      let(:string) { "mailbox {AT} example.com" }

      it "must replace ' {AT} ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox{at}domain.com'" do
      let(:string) { "mailbox{at}example.com" }

      it "must replace '{at}' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox {at} domain.com'" do
      let(:string) { "mailbox {at} example.com" }

      it "must replace ' {at} ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox(AT)domain.com'" do
      let(:string) { "mailbox(AT)example.com" }

      it "must replace '(AT)' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox (AT) domain.com'" do
      let(:string) { "mailbox (AT) example.com" }

      it "must replace ' (AT) ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox(at)domain.com'" do
      let(:string) { "mailbox(at)example.com" }

      it "must replace '(at)' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox (at) domain.com'" do
      let(:string) { "mailbox (at) example.com" }

      it "must replace ' (at) ' with '@'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain DOT com'" do
      let(:string) { "mailbox@example DOT com" }

      it "must replace ' DOT ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain dot com'" do
      let(:string) { "mailbox@example dot com" }

      it "must replace ' dot ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain[DOT]com'" do
      let(:string) { "mailbox@example[DOT]com" }

      it "must replace '[DOT]' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain [DOT] com'" do
      let(:string) { "mailbox@example [DOT] com" }

      it "must replace ' [DOT] ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain[dot]com'" do
      let(:string) { "mailbox@example[dot]com" }

      it "must replace '[dot]' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain [dot] com'" do
      let(:string) { "mailbox@example [dot] com" }

      it "must replace ' [dot] ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain<DOT>com'" do
      let(:string) { "mailbox@example<DOT>com" }

      it "must replace '<DOT>' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain <DOT> com'" do
      let(:string) { "mailbox@example <DOT> com" }

      it "must replace ' <DOT> ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain<dot>com'" do
      let(:string) { "mailbox@example<dot>com" }

      it "must replace '<dot>' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain <dot> com'" do
      let(:string) { "mailbox@example <dot> com" }

      it "must replace ' <dot> ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain{DOT}com'" do
      let(:string) { "mailbox@example{DOT}com" }

      it "must replace '{DOT}' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain {DOT} com'" do
      let(:string) { "mailbox@example {DOT} com" }

      it "must replace ' {DOT} ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain{dot}com'" do
      let(:string) { "mailbox@example{dot}com" }

      it "must replace '{dot}' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain {dot} com'" do
      let(:string) { "mailbox@example {dot} com" }

      it "must replace ' {dot} ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain(DOT)com'" do
      let(:string) { "mailbox@example(DOT)com" }

      it "must replace '(DOT)' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain (DOT) com'" do
      let(:string) { "mailbox@example (DOT) com" }

      it "must replace ' (DOT) ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain(dot)com'" do
      let(:string) { "mailbox@example(dot)com" }

      it "must replace '(dot)' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end

    context "when given 'mailbox@domain (dot) com'" do
      let(:string) { "mailbox@example (dot) com" }

      it "must replace ' (dot) ' with '.'" do
        expect(subject.deobfuscate(string)).to eq("mailbox@example.com")
      end
    end
  end

  describe "#normalize" do
    subject do
      described_class.new(
        name:    name,
        mailbox: mailbox,
        tag:     tag,
        routing: routing,
        domain:  domain
      )
    end

    let(:normalized) { subject.normalize }

    it "must return a new #{described_class} without #name, #tag, or #routing" do
      expect(normalized).to be_kind_of(described_class)
      expect(normalized).to_not be(subject)
      expect(normalized.name).to be(nil)
      expect(normalized.tag).to be(nil)
      expect(normalized.routing).to be(nil)
    end
  end

  describe "#hostname" do
    context "when #domain is set" do
      it "must return #domain" do
        expect(subject.hostname).to eq(subject.domain)
      end
    end

    context "when #address is set" do
      subject { described_class.new(mailbox: mailbox, address: address) }

      it "must return #address" do
        expect(subject.hostname).to eq(subject.address)
      end
    end
  end

  describe "#to_s" do
    it "must return the mailbox@domain" do
      expect(subject.to_s).to eq("#{mailbox}@#{domain}")
    end

    context "when #name is set" do
      subject do
        described_class.new(
          name:    name,
          mailbox: mailbox,
          domain:  domain
        )
      end

      it "must prepend the name and wrap the address in '<...>'" do
        expect(subject.to_s).to eq("#{name} <#{mailbox}@#{domain}>")
      end
    end

    context "when #routing is set" do
      context "but #routing only contains one element" do
        let(:routing) { %w[host1.com] }

        subject do
          described_class.new(
            mailbox: mailbox,
            routing: routing,
            domain:  domain
          )
        end

        it "must append '%host1' after the mailbox" do
          expect(subject.to_s).to eq(
            "#{mailbox}%#{routing[0]}@#{domain}"
          )
        end
      end

      context "and when #routing contains multiple elements" do
        let(:routing) { %w[host1.com host2.com] }

        subject do
          described_class.new(
            mailbox: mailbox,
            routing: routing,
            domain:  domain
          )
        end

        it "must append '%host1%host2%...' after the mailbox" do
          expect(subject.to_s).to eq(
            "#{mailbox}%#{routing[0]}%#{routing[1]}@#{domain}"
          )
        end
      end
    end

    context "when #tag is set" do
      subject do
        described_class.new(
          mailbox: mailbox,
          tag:     tag,
          domain:  domain
        )
      end

      it "must append '+tag' after the mailbox" do
        expect(subject.to_s).to eq("#{mailbox}+#{tag}@#{domain}")
      end

      context "but #routing is also set" do
        let(:routing) { %w[host1.com host2.com] }

        subject do
          described_class.new(
            mailbox: mailbox,
            tag:     tag,
            routing: routing,
            domain:  domain
          )
        end

        it "must append '%host1%host2%...' after the mailbox" do
          expect(subject.to_s).to eq(
            "#{mailbox}+#{tag}%#{routing[0]}%#{routing[1]}@#{domain}"
          )
        end
      end
    end
  end

  describe "#to_str" do
    subject do
      described_class.new(
        mailbox: mailbox,
        tag:     tag,
        routing: routing,
        domain:  domain
      )
    end

    it "must return #to_s" do
      expect(subject.to_str).to eq(subject.to_s)
    end
  end

  let(:obfuscated_emails) do
    [
      'john.smith @ example.com',
      'john.smith AT example.com',
      'john.smith at example.com',
      'john.smith[AT]example.com',
      'john.smith[at]example.com',
      'john.smith [AT] example.com',
      'john.smith [at] example.com',
      'john.smith<AT>example.com',
      'john.smith<at>example.com',
      'john.smith <AT> example.com',
      'john.smith <at> example.com',
      'john.smith{AT}example.com',
      'john.smith{at}example.com',
      'john.smith {AT} example.com',
      'john.smith {at} example.com',
      'john.smith(AT)example.com',
      'john.smith(at)example.com',
      'john.smith (AT) example.com',
      'john.smith (at) example.com',
      'john DOT smith AT example DOT com',
      'john dot smith at example dot com',
      'john[DOT]smith[AT]example[DOT]com',
      'john[dot]smith[at]example[dot]com',
      'john [DOT] smith [AT] example [DOT] com',
      'john [dot] smith [at] example [dot] com',
      'john<DOT>smith<AT>example<DOT>com',
      'john<dot>smith<at>example<dot>com',
      'john <DOT> smith <AT> example <DOT> com',
      'john <dot> smith <at> example <dot> com',
      'john{DOT}smith{AT}example{DOT}com',
      'john{dot}smith{at}example{dot}com',
      'john {DOT} smith {AT} example {DOT} com',
      'john {dot} smith {at} example {dot} com',
      'john(DOT)smith(AT)example(DOT)com',
      'john(dot)smith(at)example(dot)com',
      'john (DOT) smith (AT) example (DOT) com',
      'john (dot) smith (at) example (dot) com'
    ]
  end

  describe "#obfuscate" do
    it "must return an obfuscate email address" do
      expect(obfuscated_emails).to include(subject.obfuscate)
    end

    it "must return a new random obfuscated email address each time" do
      expect(subject.obfuscate).to_not eq(subject.obfuscate)
    end
  end

  describe "#each_obfuscation" do
    context "when given a block" do
      it "must yield each obfuscation" do
        expect { |b|
          subject.each_obfuscation(&b)
        }.to yield_successive_args(*obfuscated_emails)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for the method" do
        expect(subject.each_obfuscation.to_a).to eq(obfuscated_emails)
      end
    end
  end

  describe "#obfuscations" do
    it "must return an Array containing every obfuscation of the email address" do
      expect(subject.obfuscations).to eq(obfuscated_emails)
    end
  end
end
