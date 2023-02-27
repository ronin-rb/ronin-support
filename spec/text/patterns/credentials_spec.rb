require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns'

describe Ronin::Support::Text::Patterns do
  let(:fixtures_dir) { File.join(__dir__,'..','..','crypto','fixtures') }

  describe "DSA_PRIVATE_KEY" do
    subject { described_class::DSA_PRIVATE_KEY }

    let(:key_file) { File.join(fixtures_dir,'dsa.pem') }
    let(:pem)      { File.read(key_file).chomp }

    it "must match everything in between '-----BEGIN DSA PRIVATE KEY-----' and '-----END DSA PRIVATE KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN DSA PRIVATE KEY-----' and '-----END DSA PRIVATE KEY-----' blocks" do
      empty_pem = <<~DSA_PRIVATE_KEY.chomp
        -----BEGIN DSA PRIVATE KEY-----
        -----END DSA PRIVATE KEY-----
      DSA_PRIVATE_KEY

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
      empty_pem = <<~EC_PRIVATE_KEY.chomp
        -----BEGIN EC PRIVATE KEY-----
        -----END EC PRIVATE KEY-----
      EC_PRIVATE_KEY

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
      empty_pem = <<~RSA_PRIVATE_KEY
        -----BEGIN RSA PRIVATE KEY-----
        -----END RSA PRIVATE KEY-----
      RSA_PRIVATE_KEY

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
      empty_pem = <<~DSA_PRIVATE_KEY.chomp
        -----BEGIN DSA PRIVATE KEY-----
        -----END DSA PRIVATE KEY-----
      DSA_PRIVATE_KEY

      expect(empty_pem).to_not match(subject)
    end

    it "must match everything in between '-----BEGIN EC PRIVATE KEY-----' and '-----END EC PRIVATE KEY-----'" do
      expect(ec_pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN EC PRIVATE KEY-----' and '-----END EC PRIVATE KEY-----' blocks" do
      empty_pem = <<~EC_PRIVATE_KEY.chomp
        -----BEGIN EC PRIVATE KEY-----
        -----END EC PRIVATE KEY-----
      EC_PRIVATE_KEY

      expect(empty_pem).to_not match(subject)
    end

    it "must match everything in between '-----BEGIN RSA PRIVATE KEY-----' and '-----END RSA PRIVATE KEY-----'" do
      expect(rsa_pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN RSA PRIVATE KEY-----' and '-----END RSA PRIVATE KEY-----' blocks" do
      empty_pem = <<~RSA_PRIVATE_KEY.chomp
        -----BEGIN RSA PRIVATE KEY-----
        -----END RSA PRIVATE KEY-----
      RSA_PRIVATE_KEY

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "PRIVATE_KEY" do
    subject { described_class::SSH_PRIVATE_KEY }

    let(:pem) do
      <<~SSH_PRIVATE_KEY.chomp
        -----BEGIN OPENSSH PRIVATE KEY-----
        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
        L+swREJQgxmikV3PoMgaxuLhuak=
        -----END OPENSSH PRIVATE KEY-----
      SSH_PRIVATE_KEY
    end

    it "must match the data between '-----BEGIN OPENSSH PRIVATE KEY-----' and '-----END OPENSSH PRIVATE KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN OPENSSH PRIVATE KEY-----' and '-----END OPENSSH PRIVATE KEY-----' blocks" do
      empty_pem = <<~SSH_PRIVATE_KEY.chomp
        -----BEGIN OPENSSH PRIVATE KEY-----
        -----END OPENSSH PRIVATE KEY-----
      SSH_PRIVATE_KEY

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
end
