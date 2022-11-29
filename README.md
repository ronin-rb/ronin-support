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

* Provides user-friendly APIs for:
  * Bit-flipping.
  * Hexdump/unhexdump data.
  * Packing/unpacking binary data:
    * C types
    * Buffers
    * IO streams
    * Stacks
    * Strings
    * Arrays
    * Structs
    * Unions
  * Encoding data:
    * Base16
    * Base32
    * Base64
    * C strings
    * Hex
    * HTML
    * HTTP
    * JavaScript
    * PowerShell
    * Punycode
    * Quoted-printable
    * Ruby strings
    * Shell
    * SQL
    * URI
    * UUencoding
    * XML
  * Reading/writing compressed data:
    * Zlib
    * GZip
  * Reading/writing archive files:
    * Tar
    * Zip
  * Cryptography:
    * RSA
    * DSA
    * DH
    * EC
    * HMAC
    * Ciphers
    * X509 certificates
  * Networking:
    * DNS
    * UNIX
    * TCP
    * UDP
    * SSL / TLS
    * FTP
    * SMTP / ESMTP
    * POP3
    * IMAP
    * Telnet
    * HTTP / HTTPS
    * Raw packets
    * ASNs
    * IP addresses
    * IP ranges
    * TLDs
    * Public Suffix List
    * Host names
    * Domain names
  * Working with text:
    * Generating typos.
    * Generating homoglyphs.
    * Regexs for matching/extracting common types of data.
* Has 95% documentation coverage.
* Has 93% test coverage.

## Examples

For examples of the convenience methods provided by ronin-support,
please see [Everyday Ronin].

## Requirements

* [Ruby] >= 1.9.1
* [chars] ~> 0.2
* [hexdump] ~> 1.0
* [combinatorics] ~> 0.4
* [addressable] ~> 2.0
* [uri-query_params] ~> 0.8

## Install

```shell
$ gem install ronin-support
```

### Gemfile

```ruby
gem 'ronin-support', '~> 0.5'
```

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
[addressable]: https://github.com/sporkmonger/addressable#readme
[uri-query_params]: https://github.com/postmodern/uri-query_params#readme
