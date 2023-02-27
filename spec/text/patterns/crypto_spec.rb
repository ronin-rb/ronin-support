require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/crypto'

describe Ronin::Support::Text::Patterns do
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

  describe "PUBLIC_KEY" do
    subject { described_class::PUBLIC_KEY }

    let(:pem) do
      <<~PUBLIC_KEY.chomp
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
      PUBLIC_KEY
    end

    it "must match everything in between '-----BEGIN PUBLIC KEY-----' and '-----END PUBLIC KEY-----'" do
      expect(pem).to fully_match(subject)
    end

    it "must not match empty '-----BEGIN PUBLIC KEY-----' and '-----END PUBLIC KEY-----' blocks" do
      empty_pem = <<~PUBLIC_KEY.chomp
        -----BEGIN PUBLIC KEY-----
        -----END PUBLIC KEY-----
      PUBLIC_KEY

      expect(empty_pem).to_not match(subject)
    end
  end

  describe "SSH_PUBLIC_KEY" do
    subject { described_class::SSH_PUBLIC_KEY }

    it "must match 'ssh-rsa AAAA... user@domain'" do
      ssh_rsa_pubkey = <<~SSH_PUB_KEY.chomp
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQyYe+dnOTC+H/Mj6n40sNlNy64wspivT8RMrElDaBEiib+HAc9f66dCHN/27Z+sWoq0/p56hHIrsfztHLhFx51xr6/Z6UUnBmeCfP+Wm2lIWoQuepLY8/gsWNwD+Z01gMz9tciDsSbUrwybOLXY+69sTnM2PCDDvTWw5DPjHi6C1O/zJDWNBPy4fxBXpD+PK/Cx43m55emj5ZpLjQCrJvYPA5AL81R3swnBGkduvLNEMcwOaywLn5adTFsKLNwvIIUBmgZftFmTs46vlT0gxSek4E4s6fD5bJkdywu/my7vl56rPP+/kr3QjKfzfhhMR85uwQB37DPi3gu8Cqj7xp8z91cnfizVPpc5YyWgZteU12VphuU6iFJuaoQK9UFqhl5GZO1Ea8ul8k/4YaQRPdD5bUsl4tBYI4SE4ugHq1o/Homa2Syid02eCz6ILhhkk/kERnLNnlb8uoXtmuT7NQU0G52KRyEzKURLLfK+G+4d0TyEDfcVey1Q7Shhyt1KdfABdvtmugPUT0OZFpgABKDmhHJEsDazF8/6sQnAhxhDPz8tSgw60ecjBqPjFYzpfKXKjmZjTeZ7Whiv4R4oZA4Bmwkik9KfNTem8cmAmjZYUSrtS5isW0IHlIlxCMGYPMHec6CxxwpGPvgmjv+hcD9kuZeC8OePofWeLNfNOttQ== test@example.com
      SSH_PUB_KEY

      expect(ssh_rsa_pubkey).to fully_match(subject)
    end

    it "must match 'ssh-dss AAAA... user@domain'" do
      ssh_dsa_pubkey = <<~SSH_PUB_KEY.chomp
        ssh-dss AAAAB3NzaC1kc3MAAACBANTQuv28rnsPgMjQ0OBiuHYHeWdDs4iWEHkTTFSahtI+30dJQ1o8dTz38ZRy5WTIkrEC2h0WI6JjGI9anlCuOFUrxIKzotE7hjm6l7gbGygdg35zI/k8QsqCX/7pGEg7WyaQx0Y5GFl3QKzPini04ZvtyDi1C1i3OwcnjtR1yiY3AAAAFQCI7Wx0KjrHnZd4qEekHvBzWxkaOQAAAIBciaLycTTgopllldv2LjaCOlvdrCiuYPyYbwVQvpPwwuZB0CYpe9L+tvyPo3XyMvQi6xuETGzh5E0tiph0+HwUfmJV8VVZmqMInzIGNgKNP/wI1UPN2MRdzy6k3D1W/b0JL3wqzl3rIMl36lsKkvKWzL57vA9LMwKZFd+W8ELRUAAAAIEApasZdOkHW2stegT4CtASxvbY1GbQ03mQAhC9cLSOUmLwbentL7MHfW1UhD+MYRDn7+YbAxBPCqnc4goOHOt4TTKny8QAhY/BKiVhQGW0D33VmCctSjkMUZGqDI3yJPwEpmQjQFecqy4prD0ExjSWm4CyMQ4njcXG/Qf1F+gZMZ8= test@example.com
      SSH_PUB_KEY

      expect(ssh_dsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp256 AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~SSH_PUB_KEY.chomp
        ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF3ob/ktTVokdKx3E1UTDHW+60beSRSIsTfHHRHnaRAoQhaq8Y6bNk6f/48sHbFnE3AUEPwKomEQc+5wALjIbeQ= test@example.com
      SSH_PUB_KEY

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp384 AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~SSH_PUB_KEY.chomp
        ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBD2JcEAE50xLmN12XS2BF3KGRaOIy19A6Qc71eqCNPeW4cThk1AjLgDZmtny9sYffdt09wEjhqzijxtj2GDM/6IW/ox1tDCekAOVJ9H+y1BM8w31+oJnEgTpFQ1dUBO+hw== test@example.com
      SSH_PUB_KEY

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp521 AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~SSH_PUB_KEY.chomp
        ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGI+HpWu8ltNAHTZz3G0c88BsgMQH87/L6RG+jVb/Nrsdkn6nU95JvD3O24c/0RwuQxx/qxnleRb+T7oQbkMHELywDvNxv9U72MwG6d/GyKTHLIdEei+KpouMIE+jVRVlk7MczL9m/ocy8Ep+i/YAeefNshge4PZqsxxierY57t3T3UTg== test@example.com
      SSH_PUB_KEY

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ecdsa-sha2-nistp256@openssh.com AAAA... user@domain'" do
      ssh_ecdsa_pubkey = <<~SSH_PUB_KEY.chomp
        ecdsa-sha2-nistp256@openssh.com AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF3ob/ktTVokdKx3E1UTDHW+60beSRSIsTfHHRHnaRAoQhaq8Y6bNk6f/48sHbFnE3AUEPwKomEQc+5wALjIbeQ= test@example.com
      SSH_PUB_KEY

      expect(ssh_ecdsa_pubkey).to fully_match(subject)
    end

    it "must match 'ssh-ed25519 AAAA... user@domain'" do
      ssh_ed25519_pubkey = <<~SSH_PUB_KEY.chomp
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKdiXXLq/ezeabNyv1AOdc4xeUQB41kbSCXBsq9hQ7X test@example.com
      SSH_PUB_KEY

      expect(ssh_ed25519_pubkey).to fully_match(subject)
    end

    it "must match 'ssh-ed25519@openssh.com AAAA... user@domain'" do
      ssh_ed25519_pubkey = <<~SSH_PUB_KEY.chomp
        ssh-ed25519@openssh.com AAAAC3NzaC1lZDI1NTE5AAAAIFKdiXXLq/ezeabNyv1AOdc4xeUQB41kbSCXBsq9hQ7X test@example.com
      SSH_PUB_KEY

      expect(ssh_ed25519_pubkey).to fully_match(subject)
    end
  end
end
