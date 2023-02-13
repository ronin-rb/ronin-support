# ronin-support

[![CI](https://github.com/ronin-rb/ronin-support/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-support/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-support.svg)](https://codeclimate.com/github/ronin-rb/ronin-support)
[![Gem Version](https://badge.fury.io/rb/ronin-support.svg)](https://badge.fury.io/rb/ronin-support)

* [Source](https://github.com/ronin-rb/ronin-support)
* [Issues](https://github.com/ronin-rb/ronin-support/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-support/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-support is a support library for [Ronin][ronin-rb]. ronin-support provides
many Core Extensions to Ruby's built-in classes as well as its own
Classes/Modules. ronin-support can be used by other Ruby libraries, tools, or
[scripts](#examples).

**tl;dr** It's like [pwntools] combined with [activesupport].

ronin-support is part of the [ronin-rb] project, a [Ruby] toolkit for security
research and development.

## Features

* Provides user-friendly APIs for:
  * [Bit-flipping][docs-binary-bit_flip]
  * [Hexdump][hexdump] / [unhexdump][docs-unhexdump] data.
  * Packing/unpacking binary data:
    * [C types][docs-binary-ctypes]
    * [Buffers][docs-binary-buffer]
    * [IO streams][docs-binary-stream]
    * [Stacks][docs-binary-stack]
    * [Strings][docs-binary-cstring]
    * [Arrays][docs-binary-array]
    * [Structs][docs-binary-struct]
    * [Unions][docs-binary-union]
  * Encoding data:
    * [Base16][docs-encoding-base16]
    * [Base32][docs-encoding-base32]
    * [Base36][docs-encoding-base36]
    * [Base62][docs-encoding-base62]
    * [Base64][docs-encoding-base64]
    * [C strings][docs-encoding-c]
    * [Hex][docs-encoding-hex]
    * [HTML][docs-encoding-html]
    * [HTTP][docs-encoding-http]
    * [JavaScript][docs-encoding-js]
    * [PowerShell][docs-encoding-powershell]
    * [Punycode][docs-encoding-punycode]
    * [Quoted-printable][docs-encoding-quoted-printable]
    * [Ruby strings][docs-encoding-ruby]
    * [Shell][docs-encoding-shell]
    * [SQL][docs-encoding-sql]
    * [URI][docs-encoding-uri]
    * [UUencoding][docs-encoding-uuencoding]
    * [XML][docs-encoding-xml]
  * [Reading/writing compressed data][docs-compression]:
    * [Zlib][docs-compression-zlib]
    * [Gzip][docs-compression-gzip]
  * [Reading/writing archive files][docs-archive]:
    * [Tar][docs-archive-tar]
    * [Zip][docs-archive-zip]
  * [Cryptography][docs-crypto]:
    * [RSA][docs-crypto-key-rsa]
    * [DSA][docs-crypto-key-dsa]
    * [DH][docs-crypto-key-dh]
    * [EC][docs-crypto-key-ec]
    * [HMAC][docs-crypto-hmac]
    * [Ciphers][docs-crypto-cipher]
    * [X509 certificates][docs-crypto-cert]
  * Networking:
    * [DNS][docs-network-dns]
    * [UNIX][docs-network-unix-mixin]
    * [TCP][docs-network-tcp-mixin]
    * [UDP][docs-network-udp-mixin]
    * [SSL][docs-network-ssl-mixin] / [TLS][docs-network-tls-mixin]
    * [FTP][docs-network-ftp-mixin]
    * [SMTP][docs-network-smtp-mixin] / [ESMTP][docs-network-esmtp-mixin]
    * [POP3][docs-network-pop3-mixin]
    * [IMAP][docs-network-imap-mixin]
    * [Telnet][docs-network-telnet-mixin]
    * [HTTP / HTTPS][docs-network-http]
    * [Raw packets][docs-network-packet]
    * [ASNs][docs-network-asn]
    * [IP addresses][docs-network-ip]
    * [IP ranges][docs-network-ip_range]
    * [TLDs][docs-network-tld]
    * [Public Suffix List][docs-network-public_suffix]
    * [Host names][docs-network-host]
    * [Domain names][docs-network-domain]
  * Working with text:
    * [Generating typos][docs-text-typo].
    * [Generating homoglyphs][docs-text-homoglyp].
    * [Regexs for matching/extracting common types of data][docs-text-patterns].
* Adds additional methods to many of [Ruby's core classes][docs-core-exts].
* Small memory footprint (~46Kb).
* Has 96% documentation coverage.
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

* [Ruby] >= 3.0.0
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

Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)

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

[docs-binary-bit_flip]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/BitFlip.html
[docs-unhexdump]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Unhexdump.html
[docs-binary-ctypes]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/CTypes.html
[docs-binary-buffer]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Buffer.html
[docs-binary-stream]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Stream.html
[docs-binary-stack]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Stack.html
[docs-binary-cstring]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/CString.html
[docs-binary-array]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Array.html
[docs-binary-struct]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Struct.html
[docs-binary-union]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Union.html
[docs-encoding-base16]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Base16.html
[docs-encoding-base32]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Base32.html
[docs-encoding-base36]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Base36.html
[docs-encoding-base62]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Base62.html
[docs-encoding-base64]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Base64.html
[docs-encoding-c]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/C.html
[docs-encoding-hex]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Hex.html
[docs-encoding-html]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/HTML.html
[docs-encoding-http]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/HTTP.html
[docs-encoding-js]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/JS.html
[docs-encoding-powershell]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/PowerShell.html
[docs-encoding-punycode]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Punycode.html
[docs-encoding-quoted-printable]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/QuotedPrintable.html
[docs-encoding-ruby]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Ruby.html
[docs-encoding-shell]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/Shell.html
[docs-encoding-sql]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/SQL.html
[docs-encoding-uri]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/URI.html
[docs-encoding-uuencoding]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/UUEncoding.html
[docs-encoding-xml]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Encoding/XML.html
[docs-compression]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Compression.html
[docs-compression-zlib]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Compression/Zlib.html
[docs-compression-gzip]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Compression/Gzip.html
[docs-archive]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Archive.html
[docs-archive-tar]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Archive/Tar.html
[docs-archive-zip]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Archive/Zip.html
[docs-crypto]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto.html
[docs-crypto-key-rsa]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Key/RSA.html
[docs-crypto-key-dsa]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Key/DSA.html
[docs-crypto-key-dh]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Key/DH.html
[docs-crypto-key-ec]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Key/EC.html
[docs-crypto-hmac]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Key/EC.html
[docs-crypto-cipher]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Cipher.html
[docs-crypto-cert]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Crypto/Cert.html
[docs-network-dns]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/DNS.html
[docs-network-unix-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/UNIX/Mixin.html
[docs-network-tcp-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/TCP/Mixin.html
[docs-network-udp-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/UDP/Mixin.html
[docs-network-ssl-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/SSL/Mixin.html
[docs-network-tls-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/TLS/Mixin.html
[docs-network-ftp-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/FTP/Mixin.html
[docs-network-smtp-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/SMTP/Mixin.html
[docs-network-esmtp-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/ESMTP/Mixin.html
[docs-network-pop3-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/POP3/Mixin.html
[docs-network-imap-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/IMAP/Mixin.html
[docs-network-telnet-mixin]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/Telnet/Mixin.html
[docs-network-http]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/HTTP.html
[docs-network-packet]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Binary/Packet.html
[docs-network-asn]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/ASN.html
[docs-network-ip]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/IP.html
[docs-network-ip_range]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/IPRange.html
[docs-network-tld]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/TLD.html
[docs-network-public_suffix]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/PublicSuffix.html
[docs-network-host]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/Host.html
[docs-network-domain]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Network/Domain.html
[docs-text-typo]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Text/Typo.html
[docs-text-homoglyp]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Text/Homoglyph.html
[docs-text-patterns]: https://ronin-rb.dev/docs/ronin-support/Ronin/Support/Text/Patterns.html
[docs-core-exts]: https://ronin-rb.dev/docs/ronin-support/top-level-namespace.html
