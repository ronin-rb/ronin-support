# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  module Support
    module CLI
      #
      # Starts an interactive shell for the IO object,
      # where data read from the IO object is printed to STDOUT and
      # data read from STDIN is written to the IO object.
      #
      # ## Example
      #
      #     require 'ronin/support/cli/io_shell'
      #
      #     socket = TCPSocket.new('irc.undernet.org',6667)
      #     CLI::IOShell.sstart(socket)
      #
      # ```
      # NOTICE AUTH :*** Looking up your hostname
      # NOTICE AUTH :*** Checking Ident
      # NOTICE AUTH :*** Found your hostname
      # NOTICE AUTH :*** No ident response
      # USER test_ruby * * *
      # NICK test_ruby
      # PING :3167790481
      # PONG 3167790481
      # :Chicago.IL.US.Undernet.Org 001 test_ruby :Welcome to the UnderNet IRC Network, test_ruby
      # :Chicago.IL.US.Undernet.Org 002 test_ruby :Your host is Chicago.IL.US.Undernet.Org, running version u2.10.12.19
      # :Chicago.IL.US.Undernet.Org 003 test_ruby :This server was created Wed Apr 15 2020 at 22:02:43 UTC
      # :Chicago.IL.US.Undernet.Org 004 test_ruby Chicago.IL.US.Undernet.Org u2.10.12.19 diOoswkgx biklmnopstvrDdRcC bklov
      # :Chicago.IL.US.Undernet.Org 005 test_ruby WHOX WALLCHOPS WALLVOICES USERIP CPRIVMSG CNOTICE SILENCE=25 MODES=6 MAXCHANNELS=40 MAXBANS=100 NICKLEN=12 :are supported by this server
      # :Chicago.IL.US.Undernet.Org 005 test_ruby MAXNICKLEN=15 TOPICLEN=160 AWAYLEN=160 KICKLEN=160 CHANNELLEN=200 MAXCHANNELLEN=200 CHANTYPES=#& PREFIX=(ov)@+ STATUSMSG=@+ CHANMODES=b,k,l,imnpstrDdRcC CASEMAPPING=rfc1459 NETWORK=UnderNet :are supported by this server
      # :Chicago.IL.US.Undernet.Org 251 test_ruby :There are 3241 users and 9182 invisible on 38 servers
      # :Chicago.IL.US.Undernet.Org 252 test_ruby 57 :operator(s) online
      # :Chicago.IL.US.Undernet.Org 253 test_ruby 23 :unknown connection(s)
      # :Chicago.IL.US.Undernet.Org 254 test_ruby 6230 :channels formed
      # :Chicago.IL.US.Undernet.Org 255 test_ruby :I have 1179 clients and 1 servers
      # :Chicago.IL.US.Undernet.Org NOTICE test_ruby :Highest connection count: 1388 (1387 clients)
      # :Chicago.IL.US.Undernet.Org 422 test_ruby :MOTD File is missing
      # :Chicago.IL.US.Undernet.Org NOTICE test_ruby :on 1 ca 1(4) ft 10(10)
      # Ctrl^D
      # ```
      #
      class IOShell

        # The IO object to interact with.
        #
        # @return [IO]
        attr_reader :io

        # The STDIN stream.
        #
        # @return [IO]
        attr_reader :stdin

        # The STDOUT stream.
        #
        # @return [IO]
        attr_reader :stdout

        #
        # Initialies the IO shell object.
        #
        # @param [IO] io
        #   The IO object to interact with.
        #
        # @param [IO] stdin
        #   Alternative STDIN stream.
        #
        # @param [IO] stdout
        #   Alternative STDOUT stream.
        #
        def initialize(io, stdin: $stdin, stdout: $stdout)
          @io = io

          @stdin  = stdin
          @stdout = stdout
        end

        #
        # Starts the interactive shell with the given IO object.
        #
        # @param [IO] io
        #   The IO object to interact with.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#initialize}.
        #
        # @option kwargs [IO] :stdin
        #   Optional alternative STDIN stream. Defaults to `$stdin`.
        #
        # @option kwargs [IO] :stdout
        #   Optional alternative STDOUT stream. Defaults to `$stdout`.
        #
        def self.start(io,**kwargs)
          new(io,**kwargs).run
        end

        #
        # Runs the interaction shell. Data read from the IO object is
        # printed to STDOUT and data read from STDIN is written to the IO
        # object. `Ctrl^D` or `Ctrl^C` will exit the session.
        #
        # @return [Boolean]
        #   Returns `true` if the user exited the interactive shell.
        #   Returns `false` if there an IOError was encountered.
        #
        def run
          io_array = [@io, @stdin]

          loop do
            readable, _writable, errors = IO.select(io_array,nil,io_array)

            if errors.include?(@io) || errors.include?(@stdin)
              return false
            end

            if readable.include?(@io)
              data = begin
                       @io.readpartial(4096)
                     rescue EOFError
                       return false
                     end

              @stdout.write(data)
            end

            if readable.include?(@stdin)
              data = begin
                       @stdin.readpartial(4096)
                     rescue EOFError
                       return true
                     end

              @io.write(data)
            end
          end
        rescue Interrupt
          return true
        end

      end
    end
  end
end

require 'ronin/support/cli/io_shell/core_ext'
