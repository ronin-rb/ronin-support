# ronin-support

[![CI](https://github.com/ronin-rb/ronin-support/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-support/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-support.svg)](https://codeclimate.com/github/ronin-rb/ronin-support)

* [Source](https://github.com/ronin-rb/ronin-support)
* [Issues](https://github.com/ronin-rb/ronin-support/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-support/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-support is a support library for [Ronin][ronin-rb]. ronin-support provides
many Core Extensions to Ruby's built-in classes as well as it's own
Classes/Modules. ronin-support can be used by other Ruby libraries, tools, or
scripts.

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
* Small memory footprint (~46Kb).
* Has 95% documentation coverage.
* Has 93% test coverage.

## Synopsis

```shell
$ irb -r ronin/support
irb(main):001:0> "hello world".base64_encode
=> "aGVsbG8gd29ybGQ=\n"
irb(main):002:0> "aGVsbG8gd29ybGQ=\n".base64_decode
=> "hello world"
```

## Examples

```ruby
require 'ronin/support'
include Ronin::Support

string = "hello world"
puts string.base64_encode

data = "aGVsbG8gd29ybGQ=\n"
puts data.base64_decode
```

For more examples of the convenience methods provided by ronin-support,
please see the [API documentation](https://ronin-rb.dev/docs/ronin-support).

## Requirements

* [Ruby] >= 1.9.1
* [chars] ~> 0.3, >= 0.3.2
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
[Ruby]: https://www.ruby-lang.org/

[pwntools]: https://github.com/Gallopsled/pwntools#readme
[activesupport]: https://guides.rubyonrails.org/active_support_core_extensions.html

[chars]: https://github.com/postmodern/chars#readme
[hexdump]: https://github.com/postmodern/hexdump#readme
[combinatorics]: https://github.com/postmodern/combinatorics#readme
[addressable]: https://github.com/sporkmonger/addressable#readme
[uri-query_params]: https://github.com/postmodern/uri-query_params#readme
