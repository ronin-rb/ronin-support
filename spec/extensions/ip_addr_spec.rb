require 'spec_helper'
require 'ronin/extensions/ip_addr'

describe IPAddr do
  describe "CIDR addresses" do
    let(:fixed_addr) { IPAddr.new('10.1.1.2') }
    let(:class_c) { IPAddr.new('10.1.1.2/24') }

    it "should only iterate over one IP address for an address" do
      addresses = fixed_addr.map { |ip| IPAddr.new(ip) }

      addresses.length.should == 1
      fixed_addr.should include(addresses.first)
    end

    it "should iterate over all IP addresses contained within the IP range" do
      class_c.each do |ip|
        class_c.should include(IPAddr.new(ip))
      end
    end

    it "should return an Enumerator when no block is given" do
      class_c.each.all? { |ip|
        class_c.include?(IPAddr.new(ip))
      }.should == true
    end
  end

  describe "globbed addresses" do
    let(:ipv4_range) { '10.1.1-5.1' }
    let(:ipv6_range) { '::ff::02-0a::c3' }

    it "should iterate over all IP addresses in an IPv4 range" do
      IPAddr.each(ipv4_range) do |ip|
        ip.should =~ /^10\.1\.[1-5]\.1$/
      end
    end

    it "should iterate over all IP addresses in an IPv6 range" do
      IPAddr.each(ipv6_range) do |ip|
        ip.should =~ /^::ff::0[2-9a]::c3$/
      end
    end

    it "should return an Enumerator when no block is given" do
      ips = IPAddr.each(ipv4_range)
      
      ips.all? { |ip| ip =~ /^10\.1\.[1-5]\.1$/ }.should == true
    end
  end

  let(:ip) { IPAddr.new(Resolv.getaddress('www.example.com')) }

  it "should resolv the host-name for an IP" do
    ip.resolv_name.should == 'www.example.com'
  end

  it "should resolv the host-names for an IP" do
    ip.resolv_name.should include('www.example.com')
  end
end
