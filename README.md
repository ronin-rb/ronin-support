# ronin-support

* [Source](https://github.com/ronin-ruby/ronin-support)
* [Issues](https://github.com/ronin-ruby/ronin-support/issues)
* [Documentation](http://ronin-rb.dev/docs/ronin-support/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/F5Ap9B2N) |
  [Twitter](https://twitter.com/ronin_rb) |
  [IRC](http://ronin-rb.dev/irc/)

## Description

Ronin Support is a support library for Ronin. Ronin Support contains many of
the convenience methods used by Ronin and additional libraries.

[Ronin] is a Ruby platform for exploit development and security research.
Ronin allows for the rapid development and distribution of code, exploits
or payloads over many common Source-Code-Management (SCM) systems.

## Features

* Provides convenience methods for:
  * Formatting data:
    * Binary
      * Structs
    * Text
    * URIs
    * HTTP
    * HTML
    * JavaScript
    * SQL
  * Fuzzing
    * Generating
    * Mutating
  * Networking:
    * DNS
    * UNIX
    * TCP
    * UDP
    * SSL
    * FTP
    * SMTP / ESMTP
    * POP3
    * Imap
    * Telnet
    * HTTP / HTTPS
  * Enumerating IP ranges:
    * IPv4 / IPv6 addresses.
    * CIDR / globbed ranges.
  * (Un-)Hexdumping data.
  * Handling exceptions.
* Provides Modules/Classes for:
  * Paths
  * Fuzzing
  * Wordlists
  * Erb Templates
  * UI:
    * Terminal Output
    * Custom Shells

## Examples

For examples of the convenience methods provided by ronin-support,
please see [Everyday Ronin].

## Requirements

* [Ruby] >= 1.8.7
* [chars] ~> 0.2
* [hexdump] ~> 0.1
* [combinatorics] ~> 0.4
* [uri-query_params] ~> 0.6
* [data_paths] ~> 0.3
* [parameters] ~> 0.4

## Install

    $ gem install ronin-support

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-support/fork)
2. Clone It!
3. `cd ronin-support`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2006-2013 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of Ronin Support.

Ronin Support is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin Support is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.

[Ronin]: http://ronin-rb.dev/
[Everyday Ronin]: http://ronin-rb.dev/guides/everyday_ronin.html
[Ruby]: http://www.ruby-lang.org/

[chars]: https://github.com/postmodern/chars#readme
[hexdump]: https://github.com/postmodern/hexdump#readme
[combinatorics]: https://github.com/postmodern/combinatorics#readme
[uri-query_params]: https://github.com/postmodern/uri-query_params#readme
[data_paths]: https://github.com/postmodern/data_paths#readme
[parameters]: https://github.com/postmodern/parameters#readme
