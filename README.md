# ronin-support

[![CI](https://github.com/ronin-rb/ronin-support/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-support/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-support.svg)](https://codeclimate.com/github/ronin-rb/ronin-support)

* [Source](https://github.com/ronin-rb/ronin-support)
* [Issues](https://github.com/ronin-rb/ronin-support/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-support/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb)

## Description

ronin-support is a support library for [Ronin][ronin-rb]. ronin-support
contains many of the convenience methods used by Ronin and additional libraries.

It's like [pwntools] combined with [activesupport].

[Ronin][ronin-rb] is a [Ruby] toolkit for security research and development.

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
  * Cryptography
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
  * Erb Templates
  * UI:
    * Printing

## Examples

For examples of the convenience methods provided by ronin-support,
please see [Everyday Ronin].

## Requirements

* [Ruby] >= 1.9.1
* [chars] ~> 0.2
* [hexdump] ~> 1.0
* [combinatorics] ~> 0.4
* [uri-query_params] ~> 0.8
* [data_paths] ~> 0.3

## Install

    $ gem install ronin-support

### Gemfile

    gem 'ronin-support', '~> 0.5'

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-support/fork)
2. Clone It!
3. `cd ronin-support`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of ronin-support.

ronin-support is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-support is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.

[ronin-rb]: https://ronin-rb.dev
[Everyday Ronin]: https://ronin-rb.dev/guides/everyday_ronin.html
[Ruby]: https://www.ruby-lang.org/

[pwntools]: 

[chars]: https://github.com/postmodern/chars#readme
[hexdump]: https://github.com/postmodern/hexdump#readme
[combinatorics]: https://github.com/postmodern/combinatorics#readme
[uri-query_params]: https://github.com/postmodern/uri-query_params#readme
[data_paths]: https://github.com/postmodern/data_paths#readme
