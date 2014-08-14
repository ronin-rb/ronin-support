#!/usr/bin/env ruby

require 'bundler/setup'
require 'ronin/network/ssl/proxy'

Ronin::Network::SSL::Proxy.start(port: 1337, server: ['rubygems.org', 443]) do |proxy|
  address = lambda { |socket|
    addrinfo = socket.peeraddr

    "#{addrinfo[3]}:#{addrinfo[1]}"
  }

  proxy.on_client_data do |client,server,data|
    puts "#{address[client]} -> #{proxy}"
    puts data
  end

  proxy.on_client_connect do |client|
    puts "#{address[client]} -> #{proxy} [connected]"
  end

  proxy.on_client_disconnect do |client,server|
    puts "#{address[client]} <- #{proxy} [disconnected]"
  end

  proxy.on_server_data do |client,server,data|
    puts "#{address[client]} <- #{proxy}"
    puts data
  end

  proxy.on_server_connect do |client,server|
    puts "#{address[client]} <- #{proxy} [connected]"
  end

  proxy.on_server_disconnect do |client,server|
    puts "#{address[client]} <- #{proxy} [disconnected]"
  end
end
