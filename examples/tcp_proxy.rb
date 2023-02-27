#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'ronin/support/network/tcp/proxy'
require 'hexdump'

Ronin::Support::Network::TCP::Proxy.start(port: 1337, server: ['www.wired.com', 80]) do |proxy|
  address = ->(socket) {
    addrinfo = socket.peeraddr

    "#{addrinfo[3]}:#{addrinfo[1]}"
  }

  hexdump = Hexdump::Dumper.new

  proxy.on_client_data do |client,server,data|
    puts "#{address[client]} -> #{proxy}"
    hexdump.dump(data)
  end

  proxy.on_client_connect do |client|
    puts "#{address[client]} -> #{proxy} [connected]"
  end

  proxy.on_client_disconnect do |client,server|
    puts "#{address[client]} <- #{proxy} [disconnected]"
  end

  proxy.on_server_data do |client,server,data|
    puts "#{address[client]} <- #{proxy}"
    hexdump.dump(data)
  end

  proxy.on_server_connect do |client,server|
    puts "#{address[client]} <- #{proxy} [connected]"
  end

  proxy.on_server_disconnect do |client,server|
    puts "#{address[client]} <- #{proxy} [disconnected]"
  end
end
