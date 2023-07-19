require 'spec_helper'
require 'ronin/support/crypto/cert'
require 'ronin/support/crypto/key/rsa'
require 'ronin/support/crypto/key/dsa'
require 'ronin/support/crypto/key/ec'

require 'tempfile'

describe Ronin::Support::Crypto::Cert do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  describe described_class::Name do
    describe ".build" do
      subject { described_class }

      it "must return a #{described_class} object" do
        expect(subject.build).to be_kind_of(described_class)
      end

      context "when given the common_name: keyword argument" do
        let(:common_name) { 'example.com' }

        subject { super().build(common_name: common_name) }

        it "must add a CN= entry" do
          expect(subject.to_s).to eq("/CN=#{common_name}")
        end
      end

      context "when given the email_address: keyword argument" do
        let(:email_address) { 'john.smith@example.com' }

        subject { super().build(email_address: email_address) }

        it "must add an emailAddress= entry" do
          expect(subject.to_s).to eq("/emailAddress=#{email_address}")
        end
      end

      context "when given the organizational_unit: keyword argument" do
        let(:organizational_unit) { 'IT' }

        subject { super().build(organizational_unit: organizational_unit) }

        it "must add a OU= entry" do
          expect(subject.to_s).to eq("/OU=#{organizational_unit}")
        end
      end

      context "when given the organizational: keyword argument" do
        let(:organization) { 'Mega Corp, Inc.' }

        subject { super().build(organization: organization) }

        it "must add a O= entry" do
          expect(subject.to_s).to eq("/O=#{organization}")
        end
      end

      context "when given the locality: keyword argument" do
        let(:locality) { 'Mountain View' }

        subject { super().build(locality: locality) }

        it "must add a L= entry" do
          expect(subject.to_s).to eq("/L=#{locality}")
        end
      end

      context "when given the state: keyword argument" do
        let(:state) { 'California' }

        subject { super().build(state: state) }

        it "must add a ST= entry" do
          expect(subject.to_s).to eq("/ST=#{state}")
        end
      end

      context "when given the province: keyword argument" do
        let(:province) { 'California' }

        subject { super().build(province: province) }

        it "must add a ST= entry" do
          expect(subject.to_s).to eq("/ST=#{province}")
        end
      end

      context "when given the country: keyword argument" do
        let(:country) { 'US' }

        subject { super().build(country: country) }

        it "must add a C= entry" do
          expect(subject.to_s).to eq("/C=#{country}")
        end
      end
    end

    let(:common_name)         { 'test' }
    let(:organization)        { 'Test, Inc.' }
    let(:organizational_unit) { 'Test Dept' }
    let(:locality)            { 'Test City' }
    let(:state)               { 'XX' }
    let(:country)             { 'US' }

    subject do
      described_class.new(
        [
          ['CN', common_name],
          ['O',  organization],
          ['OU', organizational_unit],
          ['L',  locality],
          ['ST', state],
          ['C',  country]
        ]
      )
    end

    describe "#entries" do
      it "must return a Hash of the entries" do
        expect(subject.entries).to eq(
          {
            'CN' => common_name,
            'O'  => organization,
            'OU' => organizational_unit,
            'L'  => locality,
            'ST' => state,
            'C'  => country
          }
        )
      end

      it "must convert all values to UTF-8 Strings" do
        values = subject.entries.values

        expect(values.map(&:encoding)).to all(be(Encoding::UTF_8))
      end
    end

    describe "#[]" do
      context "when given an OID name of an entry in the name" do
        it "must return the corresponding value" do
          expect(subject['CN']).to eq(common_name)
        end
      end

      context "when given an unknown OID name" do
        it "must return nil" do
          expect(subject['FOO']).to eq(nil)
        end
      end
    end

    describe "#common_name" do
      it "must return the 'CN' entry value" do
        expect(subject.common_name).to eq(common_name)
      end
    end

    describe "#organization" do
      it "must return the 'O' entry value" do
        expect(subject.organization).to eq(organization)
      end
    end

    describe "#organizational_unit" do
      it "must return the 'OU' entry value" do
        expect(subject.organizational_unit).to eq(organizational_unit)
      end
    end

    describe "#locality" do
      it "must return the 'L' entry value" do
        expect(subject.locality).to eq(locality)
      end
    end

    describe "#state" do
      it "must return the 'ST' entry value" do
        expect(subject.state).to eq(state)
      end
    end

    describe "#country" do
      it "must return the 'C' entry value" do
        expect(subject.country).to eq(country)
      end
    end
  end

  describe "Name()" do
    subject { described_class }

    let(:common_name)  { "test" }
    let(:organization) { "Test" }

    context "when given a String" do
      let(:string) { "/CN=#{common_name}/O=#{organization}" }

      it "must parse the String and return a #{described_class}::Name" do
        name = subject.Name(string)

        expect(name).to be_kind_of(described_class::Name)
        expect(name.to_s).to eq(string)
      end
    end

    context "when given a Hash" do
      let(:hash) do
        {common_name: common_name, organization: organization}
      end

      it "must build a #{described_class}::Name object" do
        name = subject.Name(hash)

        expect(name).to eq(described_class::Name.build(**hash))
      end
    end

    context "when given a OpenSSL::X509::Name object" do
      let(:name) { OpenSSL::X509::Name.new }

      it "must return #{described_class}::Name object" do
        expect(subject.Name(name)).to be_kind_of(described_class::Name)
      end

      it "must copy the entries of the name" do
        expect(subject.Name(name).to_a).to eq(name.to_a)
      end
    end

    context "when given a #{described_class::Name} object" do
      let(:name) { described_class::Name.new }

      it "must return the #{described_class::Name} object" do
        expect(subject.Name(name)).to be(name)
      end
    end

    context "when given another kind of object" do
      let(:object) { Object.new }

      it do
        expect {
          subject.Name(object)
        }.to raise_error(ArgumentError,"value must be either a String, Hash, or a OpenSSL::X509::Name object: #{object.inspect}")
      end
    end
  end

  let(:cert_path) { File.join(fixtures_dir,"cert.crt") }

  describe ".parse" do
    subject { described_class }

    let(:string) { File.read(cert_path) }

    it "must return a #{described_class} object" do
      expect(subject.parse(string)).to be_kind_of(described_class)
    end

    it "must return the last certificate in the string" do
      last_cert = OpenSSL::X509::Certificate.new(string)

      expect(subject.parse(string).to_pem).to eq(last_cert.to_pem)
    end
  end

  describe ".load" do
    subject { described_class }

    let(:buffer) { File.read(cert_path) }

    it "must return a #{described_class} object" do
      expect(subject.load(buffer)).to be_kind_of(described_class)
    end

    it "must return the last certificate in the file" do
      last_cert = OpenSSL::X509::Certificate.new(buffer)

      expect(subject.load(buffer).to_pem).to eq(last_cert.to_pem)
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must return a #{described_class} object" do
      expect(subject.load_file(cert_path)).to be_kind_of(described_class)
    end

    it "must return the last certificate in the file" do
      last_cert = OpenSSL::X509::Certificate.new(File.read(cert_path))

      expect(subject.load_file(cert_path).to_pem).to eq(last_cert.to_pem)
    end
  end

  let(:rsa_key_path) { File.join(fixtures_dir,"rsa.pem") }
  let(:rsa_key) do
    Ronin::Support::Crypto::Key::RSA.load_file(rsa_key_path)
  end

  let(:dsa_key_path) { File.join(fixtures_dir,"dsa.pem") }
  let(:dsa_key) do
    Ronin::Support::Crypto::Key::DSA.load_file(dsa_key_path)
  end

  let(:ec_key_path) { File.join(fixtures_dir,"ec.pem") }
  let(:ec_key) do
    Ronin::Support::Crypto::Key::EC.load_file(ec_key_path)
  end

  describe ".generate" do
    let(:common_name)         { 'test' }
    let(:organization)        { 'Test, Inc.' }
    let(:organizational_unit) { 'Test Dept' }
    let(:locality)            { 'Test City' }
    let(:state)               { 'XX' }
    let(:country)             { 'US' }
    let(:subject_alt_name)    { 'DNS:test.localhost' }
    let(:extensions) do
      {
        'subjectAltName' => subject_alt_name
      }
    end

    subject do
      Ronin::Support::Crypto::Cert.generate(key: rsa_key)
    end

    it "must generate a new #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must default #version to 2" do
      expect(subject.version).to eq(2)
    end

    context "when the version: keyword argument is given" do
      let(:version) { 1 }

      subject do
        Ronin::Support::Crypto::Cert.generate(
          version: version,
          key:     rsa_key,
          subject: {
            common_name:         common_name,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          },
          extensions: extensions
        )
      end

      it "must set #version" do
        expect(subject.version).to eq(version)
      end
    end

    it "must default #{described_class}#serial to 0" do
      expect(subject.serial).to eq(0)
    end

    context "when the serial: keyword argument is given" do
      let(:serial) { 1 }

      subject do
        Ronin::Support::Crypto::Cert.generate(
          serial: serial,
          key:    rsa_key,
          subject: {
            common_name:         common_name,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          },
          extensions: extensions
        )
      end

      it "must set #serial" do
        expect(subject.serial).to eq(serial)
      end
    end

    it "must leave #subject blank by default" do
      expect(subject.subject.to_s).to eq("")
    end

    context "when the subject: keyword argument is given" do
      subject do
        Ronin::Support::Crypto::Cert.generate(
          key:    rsa_key,
          subject: {
            common_name:         common_name,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          },
          extensions: extensions
        )
      end

      it "must build a #subject name using the given Hash of values" do
        expect(subject.subject).to be_kind_of(OpenSSL::X509::Name)
        expect(subject.subject.to_s).to eq(
          "/CN=#{common_name}/OU=#{organizational_unit}/O=#{organization}/L=#{locality}/ST=#{state}/C=#{country}"
        )
      end
    end

    it "must default #issuer to #subject" do
      expect(subject.issuer).to eq(subject.subject)
    end

    context "when the extensions: keyword is given" do
      subject do
        Ronin::Support::Crypto::Cert.generate(
          key:        rsa_key,
          extensions: extensions
        )
      end

      it "must populate #extensions using the given Hash of extensions" do
        extension = subject.find_extension('subjectAltName')

        expect(extension).to_not be(nil)
        expect(extension.value).to eq(subject_alt_name)
      end

      context "when an extension is an Array of the value and critical" do
        let(:extension_name) { 'basicConstraints' }
        let(:extensions) do
          {extension_name => ['CA:FALSE', true]}
        end

        it "must set the #critical? of the new extension" do
          extension = subject.find_extension(extension_name)

          expect(extension).to_not be(nil)
          expect(extension.critical?).to be(true)
        end
      end
    end

    it "must default #not_before to Time.now" do
      time = Time.now
      allow(Time).to receive(:now).and_return(time)

      expect(subject.not_before).to be_within(1).of(time)
    end

    context "when the not_before: keyword argument is given" do
      let(:not_before) { Time.now - 60 }

      subject do
        Ronin::Support::Crypto::Cert.generate(
          key:        rsa_key,
          not_before: not_before,
          subject: {
            common_name:         common_name,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          },
          extensions: extensions
        )
      end

      it "must set #not_before" do
        expect(subject.not_before).to be_within(1).of(not_before)
      end
    end

    let(:now)               { Time.now }
    let(:one_year_from_now) { now + (60 * 60 * 24 * 365) }

    it "must default #not_after to one year from not_before" do
      allow(Time).to receive(:now).and_return(now)

      expect(subject.not_after).to be_within(1).of(one_year_from_now)
    end

    context "when the not_after: keyword argument is given" do
      let(:not_after) { Time.now + 60 }

      subject do
        Ronin::Support::Crypto::Cert.generate(
          key:       rsa_key,
          not_after: not_after,
          subject: {
            common_name:         common_name,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          },
          extensions: extensions
        )
      end

      it "must set #not_after" do
        expect(subject.not_after).to be_within(1).of(not_after)
      end
    end

    context "when key: is an RSA key" do
      it "must set the #public_key to the given RSA key's #public_key" do
        expect(subject.public_key.to_pem).to eq(rsa_key.public_key.to_pem)
      end

      it "must sign the certificate with the given RSA key" do
        expect(subject.verify(rsa_key)).to be(true)
      end
    end

    context "when key: is a DSA key" do
      subject do
        Ronin::Support::Crypto::Cert.generate(key: dsa_key)
      end

      it "must set the #public_key to the given DSA key's #public_key" do
        expect(subject.public_key.to_pem).to eq(dsa_key.public_key.to_pem)
      end

      it "must sign the certificate with the given DSA key" do
        expect(subject.verify(dsa_key)).to be(true)
      end
    end

    context "when key: is a EC key" do
      subject do
        Ronin::Support::Crypto::Cert.generate(key: ec_key)
      end

      it "must set the #public_key to the EC key" do
        expect(subject.public_key.to_pem).to eq(ec_key.to_pem)
      end
    end

    context "when the ca_key: and ca_key: keyword arguments are given" do
      let(:ca_key) { Ronin::Support::Crypto::Key::RSA.random(1024) }

      let(:ca_cert) do
        Ronin::Support::Crypto::Cert.generate(
          key:    ca_key,
          subject: {
            common_name:         'test-ca.com',
            organization:        'Test CA',
            organizational_unit: 'Test Dept',
            locality:            'Test City',
            state:               'XX',
            country:             'US'
          },
          extensions: {
            'basicConstraints' => ['CA:true', false]
          }
        )
      end

      subject do
        Ronin::Support::Crypto::Cert.generate(
          key:       rsa_key,
          ca_key:    ca_key,
          ca_cert:   ca_cert,
          subject: {
            common_name:         common_name,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          },
          extensions: extensions
        )
      end

      it "must set #serial to the CA cert's #serial + 1" do
        expect(subject.serial).to eq(ca_cert.serial + 1)
      end

      it "must sign the certificate using the given CA key" do
        expect(subject.verify(ca_key)).to be(true)
      end

      it "must set #issuer to the CA cert's #subject" do
        expect(subject.issuer).to eq(ca_cert.subject)
      end
    end
  end

  subject { described_class.new(File.read(cert_path)) }

  describe "#issuer" do
    it "must return the issuer as a #{described_class}::Name" do
      expect(subject.issuer).to be_kind_of(described_class::Name)
    end

    it "must return the same object" do
      expect(subject.issuer).to be(subject.issuer)
    end
  end

  describe "#subject" do
    it "must return the subject as a #{described_class}::Name" do
      expect(subject.subject).to be_kind_of(described_class::Name)
    end

    it "must return the same object" do
      expect(subject.subject).to be(subject.subject)
    end
  end

  describe "#common_name" do
    it "must return the command name from the subject" do
      expect(subject.common_name).to eq('www.example.org')
    end
  end

  describe "#extension_names" do
    it "must return the OID names of all extensions" do
      expect(subject.extension_names).to eq(
        [
          "authorityKeyIdentifier",
          "subjectKeyIdentifier",
          "subjectAltName",
          "keyUsage",
          "extendedKeyUsage",
          "crlDistributionPoints",
          "certificatePolicies",
          "authorityInfoAccess",
          "basicConstraints",
          "ct_precert_scts"
        ]
      )
    end
  end

  describe "#extensions_hash" do
    it "must return a Hash of extension OID names and Extensions" do
      expect(subject.extensions_hash).to eq(
        subject.extensions.to_h { |ext| [ext.oid, ext] }
      )
    end
  end

  describe "#extension_value" do
    it "must return the value of the extension with the OID name" do
      expect(subject.extension_value('keyUsage')).to eq(
        subject.find_extension('keyUsage').value
      )
    end

    context "but no such extension exists with the OID name" do
      it "must return nil" do
        expect(subject.extension_value('foo')).to be(nil)
      end
    end
  end

  describe "#subject_alt_name" do
    let(:extension) { subject.find_extension('subjectAltName') }

    it "must return the value of the subjectAltName extension" do
      expect(subject.subject_alt_name).to eq(extension.value)
    end

    context "but the certificate does not have a subjectAltName extension" do
      before do
        subject.extensions = subject.extensions.reject do |ext|
          ext.oid == 'subjectAltName'
        end
      end

      it "must return nil" do
        expect(subject.subject_alt_name).to be(nil)
      end
    end
  end

  describe "#subject_alt_names" do
    let(:extension) do
      subject.extensions.find { |ext| ext.oid == 'subjectAltName' }
    end

    it "must return the parsed names within the subjectAltName extension" do
      expect(subject.subject_alt_names).to eq(
        %w[
          www.example.org
          example.net
          example.edu
          example.com
          example.org
          www.example.com
          www.example.edu
          www.example.net
        ]
      )
    end

    context "but the certificate does not have a subjectAltName extension" do
      before do
        subject.extensions = subject.extensions.reject do |ext|
          ext.oid == 'subjectAltName'
        end
      end

      it "must return nil" do
        expect(subject.subject_alt_names).to be(nil)
      end
    end
  end

  describe "#save" do
    subject do
      Ronin::Support::Crypto::Cert.generate(
        key: rsa_key,
        subject: {
          common_name: 'test',
          organization: 'Test, Inc.',
          organizational_unit: 'Test Dept',
          locality: 'Test City',
          state: 'XX',
          country: 'US'
        },
        extensions: {
          'subjectAltName' => 'DNS: test.localhost'
        }
      )
    end

    let(:tempfile)  { Tempfile.new('ronin-support') }
    let(:save_path) { tempfile.path }

    context "when no keyword arguments are given" do
      before { subject.save(save_path) }

      it "must write the PEM encoded certificate to the file" do
        expect(File.read(save_path)).to eq(subject.to_pem)
      end
    end

    context "when the encoding: :der keyword argument is given" do
      before { subject.save(save_path, encoding: :der) }

      it "must write the DER encoded certificate to the file" do
        expect(File.binread(save_path)).to eq(subject.to_der)
      end
    end

    context "when the encoding: keyword argument is neither :pem or :der" do
      let(:encoding) { :foo }

      it do
        expect {
          subject.save(save_path, encoding: encoding)
        }.to raise_error(ArgumentError,"encoding: keyword argument (#{encoding.inspect}) must be either :pem or :der")
      end
    end
  end

  describe "Cert()" do
    let(:string) { File.read(cert_path) }
    let(:cert) { OpenSSL::X509::Certificate.new(string) }

    context "when given a String" do
      subject { Ronin::Support::Crypto::Cert(string) }

      it "must return a #{described_class} object" do
        expect(subject).to be_kind_of(described_class)
      end

      it "must return the parsed certificate from the string" do
        cert = OpenSSL::X509::Certificate.new(string)

        expect(subject.to_pem).to eq(cert.to_pem)
      end
    end

    context "when given an OpenSSL::X509::Certificate object" do
      subject { Ronin::Support::Crypto::Cert(string) }

      it "must return a #{described_class} object created from the OpenSSL::X509::Certificate object" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.to_pem).to eq(cert.to_pem)
      end
    end

    context "when given a #{described_class} object" do
      let(:cert) { described_class.new }

      subject { Ronin::Support::Crypto::Cert(cert) }

      it "must return the #{described_class} object" do
        expect(subject).to be(cert)
      end
    end

    context "when given another kind of Object" do
      let(:object) { Object.new }

      it do
        expect {
          Ronin::Support::Crypto::Cert(object)
        }.to raise_error(ArgumentError,"value must be either a String or a OpenSSL::X509::Certificate object: #{object.inspect}")
      end
    end
  end
end
