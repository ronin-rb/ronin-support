### 1.1.0 / 2023-XX-XX

* Added {Ronin::Support::Binary::CTypes::OS::Android}.
* Added {Ronin::Support::Binary::CTypes::OS::AppleIOS}.

### 1.0.7 / 2024-07-13

* Improved the performance of {Ronin::Support::Encoding::JS.unescape} and
  {String#js_unescape} by 2x.
* Correctly parse Unicode surrogate character pairs in JavaScript
  strings (ex: `"\uD83D\uDE80"`) in {Ronin::Support::Encoding::JS.unescape},
  {String#js_unescape}, {Ronin::Support::Encoding::JS.unquote}, and
  {String#js_unquote}.

### 1.0.6 / 2024-06-19

* Fixed error messages in {Ronin::Support::Encoding::Base64.encode} and
  {Ronin::Support::Encoding::Base64.decode}.
* Fixed {Ronin::Support::Network::IPRange::Glob#each} to support `*` in IPv6
  glob ranges.
* {Ronin::Support::Network::TCP.connect},
  {Ronin::Support::Network::UDP.connect}, and
  {Ronin::Support::Network::HTTP.connect}, when given a block, now returns the
  block's return value.
* {Ronin::Support::Network::TCP.connect} and
  {Ronin::Support::Network::UDP.connect} properly closes the socket when passed
  a block that raises an exception.

### 1.0.5 / 2023-12-27

* Fixed a bug in {Ronin::Support::Binary::Stream::Methods#read_string} on Ruby
  3.3.0.

### 1.0.4 / 2023-12-15

* Fixed a bug in {Array#pack} where complex types (ex: `[[:uint32, 4], 10]`)
  were not being packed correctly.
* Fixed a bug in {String#unpack} where complex types (ex: `[[:uint32, 4], 10]`)
  were not being unpacked correctly.
* Fixed a bug in {Ronin::Support::Binary::CTypes::ObjectType#initialize} when
  the object's type has an infinite size, such as an unbounded Array type.
* Allow using non-RSA keys in all SSL/TLS methods.

### 1.0.3 / 2023-09-19

* {Ronin::Support::Crypto::Cert::Name#entries} now returns UTF-8 encoded
  Strings.
* {Ronin::Support::Crypto::Cert.Name} now passes through
  {Ronin::Support::Crypto::Cert::Name} objects instead of copying them.
* Fixed a bug in {Ronin::Support::Crypto::Cert.generate} when it is given a
  `OpenSSL::PKey::EC` signing key.
* Fixed a bug in {Ronin::Support::Network::SSL::Mixin#ssl_connect} where the
  `OpenSSL::SSL::SSLSocket#hostname` attribute was not being set to the
  host being connected to, which prevented connecting to TLS servers that use
  SNI.
* Fixed {Ronin::Support::Network::IP#set} to return `self`.
* Fixed {Ronin::Support::Network::IP#inspect} to call the lazy-initialized
  {Ronin::Support::Network::IP#address} method instead of the `@address`
  instance variable directly.

### 1.0.2 / 2023-06-09

* Fixed a bug in {Ronin::Support::Encoding::Base32.decode},
  {Ronin::Support::Encoding::Hex.unescape},
  {Ronin::Support::Encoding::C.unescape},
  {Ronin::Support::Encoding::JS.unescape},
  {Ronin::Support::Encoding::PowerShell.unescape},
  {Ronin::Support::Encoding::Ruby.unescape},
  {Ronin::Support::Encoding::XML.unescape},
  {Ronin::Support::Path#join}, {String#encode_bytes}, and {String#encode_chars}
  where ASCII-bit Strings were always being returned instead of UTF-8 Strings.
* Fixed a bug where {Ronin::Support::Network::IP#address} was being improperly
  cached.
* Added missing `require` for {File.tar}, {File.untar}, {File.zip}, and
  {File.unzip} core-ext methods.
* Added missing `require` for {Integer#pack} and {Float#pack} core-ext methods.
* No longer include {Ronin::Support::Mixin} into {Kernel} which caused Mixin
  methods to be included into *every* Class and object.
* Added more example code to documentation.
* Documentation fixes.

### 1.0.1 / 2023-03-01

* {Ronin::Support::Network::HTTP.connect_uri} can now infer when to enable
  SSL/TLS from the given URI.
* {Ronin::Support::Network::HTTP.connect_uri} can now use the `user` and
  `password` information from the given URI.
* All {Ronin::Support::Network::HTTP} class methods which accept URI objects
  can now accept URLs with International Domain Names (IDN).
* Changed {Kernel#try} to not silently ignore `SyntaxError` exceptions.
* Documentation improvements.

### 1.0.0 / 2023-02-01

* Added {File.aes_encrypt}.
* Added {File.aes_decrypt}.
* Added {File.aes128_encrypt}.
* Added {File.aes128_decrypt}.
* Added {File.aes256_encrypt}.
* Added {File.aes256_decrypt}.
* Added {File.rsa_encrypt}.
* Added {File.rsa_decrypt}.
* Added {File.gzip}.
* Added {File.gunzip}.
* Added {File.tar}.
* Added {File.untar}.
* Added {File.zip}.
* Added {File.unzip}.
* Added {Integer#c_escape}.
* Added {Integer#c_encode}.
* Added {Integer#powershell_encode}.
* Added {Integer#powershell_escape}.
* Added {Integer#shell_encode}.
* Added {Integer#shell_escape}.
* Added {Integer#uri_form_escape}.
* Added {Integer#uri_form_encode}.
* Added {Integer#to_hex}.
* Added {Integer#to_int8}.
* Added {Integer#to_int16}.
* Added {Integer#to_int32}.
* Added {Integer#to_int64}.
* Added {Integer#to_uint8}.
* Added {Integer#to_uint16}.
* Added {Integer#to_uint32}.
* Added {Integer#to_uint64}.
* Added {String#base16_encode}.
* Added {String#base16_decode}.
* Added {String#base32_encode}.
* Added {String#base32_decode}.
* Added {String#c_escape}.
* Added {String#c_unescape}.
* Added {String#c_encode}.
* Added {String#c_string}.
* Added {String#c_unquote}.
* Added {String#hex_string}.
* Added {String#hex_unquote}.
* Added {String#http_encode}.
* Added {String#js_encode}.
* Added {String#js_string}.
* Added {String#js_unquote}.
* Added {String#powershell_escape}.
* Added {String#powershell_unescape}.
* Added {String#powershell_encode}.
* Added {String#powershell_string}.
* Added {String#powershell_unquote}.
* Added {String#punycode_encode}.
* Added {String#punycode_decode}.
* Added {String#quoted_printable_escape}.
* Added {String#quoted_printable_unescape}.
* Added {String#ruby_escape}.
* Added {String#ruby_unescape}.
* Added {String#ruby_encode}.
* Added {String#ruby_string}.
* Added {String#ruby_unquote}.
* Added {String#shell_escape}.
* Added {String#shell_unescape}.
* Added {String#shell_encode}.
* Added {String#shell_string}.
* Added {String#shell_unquote}.
* Added {String#sql_unescape}.
* Added {String#uri_form_escape}.
* Added {String#uri_form_encode}.
* Added {String#uu_encode}.
* Added {String#uu_decode}.
* Added {String#xml_encode}.
* Added {String#aes_encrypt}.
* Added {String#aes_decrypt}.
* Added {String#aes128_encrypt}.
* Added {String#aes128_decrypt}.
* Added {String#aes256_encrypt}.
* Added {String#aes256_decrypt}.
* Added {String#rsa_encrypt}.
* Added {String#rsa_decrypt}.
* Added {String#gzip}.
* Added {String#gunzip}.
* Added {String#entropy}.
* Added {String#homoglyph}.
* Added {String#each_homoglyph}.
* Added {String#homoglyphs}.
* Added {String#typo}.
* Added {String#each_typo}.
* Added {String#typos}.
* Added {Ronin::Support::Archive}.
* Added {Ronin::Support::Archive::Tar}.
* Added {Ronin::Support::Archive::Zip}.
* Added {Ronin::Support::Archive::Mixin}.
* Added {Ronin::Support::Binary::CTypes}.
* Added {Ronin::Support::Binary::Array}.
* Added {Ronin::Support::Binary::Memory}.
* Added {Ronin::Support::Binary::Buffer}.
* Added {Ronin::Support::Binary::CString}.
* Added {Ronin::Support::Binary::Stack}.
* Added {Ronin::Support::Binary::Stream}.
* Added {Ronin::Support::Binary::Union}.
* Added {Ronin::Support::Binary::Unhexdump::Parser#unpack}.
* Added {Ronin::Support::Binary::Unhexdump::Parser#unhexdump}.
* Added {Ronin::Support::CLI::ANSI}.
* Added {Ronin::Support::CLI::Printing}.
* Added {Ronin::Support::Compression}.
* Added {Ronin::Support::Compression::Gzip}.
* Added {Ronin::Support::Compression::Gzip::Reader}.
* Added {Ronin::Support::Compression::Gzip::Writer}.
* Added {Ronin::Support::Compression::Mixin}.
* Added {Ronin::Support::Crypto}.
* Added {Ronin::Support::Crypto::HMAC}.
* Added {Ronin::Support::Crypto::Key}.
* Added {Ronin::Support::Crypto::Key::DH}.
* Added {Ronin::Support::Crypto::Key::DSA}.
* Added {Ronin::Support::Crypto::Key::EC}.
* Added {Ronin::Support::Crypto::Key::RSA}.
* Added {Ronin::Support::Crypto::Mixin}.
* Added {Ronin::Support::Encoding}.
* Added {Ronin::Support::Encoding::Base16}.
* Added {Ronin::Support::Encoding::Base32}.
* Added {Ronin::Support::Encoding::Base64}.
* Added {Ronin::Support::Encoding::C}.
* Added {Ronin::Support::Encoding::Hex}.
* Added {Ronin::Support::Encoding::HTML}.
* Added {Ronin::Support::Encoding::HTTP}.
* Added {Ronin::Support::Encoding::JS}.
* Added {Ronin::Support::Encoding::PowerShell}.
* Added {Ronin::Support::Encoding::Punycode}.
* Added {Ronin::Support::Encoding::QuotedPrintable}.
* Added {Ronin::Support::Encoding::Ruby}.
* Added {Ronin::Support::Encoding::Shell}.
* Added {Ronin::Support::Encoding::SQL}.
* Added {Ronin::Support::Encoding::URI}.
* Added {Ronin::Support::Encoding::UUEncoding}.
* Added {Ronin::Support::Encoding::XML}.
* Added {Ronin::Support::Home}.
* Added {Ronin::Support::Mixin}.
* Added {Ronin::Support::Network::ASN}.
* Added {Ronin::Support::Network::ASN::List}.
* Added {Ronin::Support::Network::DNS::IDN}.
* Added {Ronin::Support::Network::DNS::Resolver}.
* Added {Ronin::Support::Network::Domain}.
* Added {Ronin::Support::Network::EmailAddress}.
* Added {Ronin::Support::Network::Host}.
* Refactored {Ronin::Support::Network::HTTP} into a class.
* Added {Ronin::Support::Network::HTTP.connect}.
* Added {Ronin::Support::Network::HTTP.connect_uri}.
* Added {Ronin::Support::Network::HTTP#ssl?}.
* Added {Ronin::Support::Network::HTTP#user_agent}.
* Added {Ronin::Support::Network::HTTP#user_agent=}.
* Added {Ronin::Support::Network::HTTP#cookie=}.
* Added {Ronin::Support::Network::HTTP#request}.
* Added {Ronin::Support::Network::HTTP#response_status}.
* Added {Ronin::Support::Network::HTTP#ok?}.
* Added {Ronin::Support::Network::HTTP#response_headers}.
* Added {Ronin::Support::Network::HTTP#server_header}.
* Added {Ronin::Support::Network::HTTP#powered_by_header}.
* Added {Ronin::Support::Network::HTTP#response_body}.
* Added {Ronin::Support::Network::HTTP#copy}.
* Added {Ronin::Support::Network::HTTP#delete}.
* Added {Ronin::Support::Network::HTTP#get}.
* Added {Ronin::Support::Network::HTTP#get_headers}.
* Added {Ronin::Support::Network::HTTP#get_cookies}.
* Added {Ronin::Support::Network::HTTP#get_body}.
* Added {Ronin::Support::Network::HTTP#head}.
* Added {Ronin::Support::Network::HTTP#lock}.
* Added {Ronin::Support::Network::HTTP#mkcol}.
* Added {Ronin::Support::Network::HTTP#move}.
* Added {Ronin::Support::Network::HTTP#options}.
* Added {Ronin::Support::Network::HTTP#allowed_methods}.
* Added {Ronin::Support::Network::HTTP#patch}.
* Added {Ronin::Support::Network::HTTP#post}.
* Added {Ronin::Support::Network::HTTP#post_headers}.
* Added {Ronin::Support::Network::HTTP#post_body}.
* Added {Ronin::Support::Network::HTTP#propfind}.
* Added {Ronin::Support::Network::HTTP#proppatch}.
* Added {Ronin::Support::Network::HTTP#put}.
* Added {Ronin::Support::Network::HTTP#trace}.
* Added {Ronin::Support::Network::HTTP#unlock}.
* Added {Ronin::Support::Network::HTTP#close}.
* Added {Ronin::Support::Network::HTTP.response_status}.
* Added {Ronin::Support::Network::HTTP.ok?}.
* Added {Ronin::Support::Network::HTTP.response_headers}.
* Added {Ronin::Support::Network::HTTP.server_header}.
* Added {Ronin::Support::Network::HTTP.powered_by_header}.
* Added {Ronin::Support::Network::HTTP.response_body}.
* Added {Ronin::Support::Network::HTTP.copy}.
* Added {Ronin::Support::Network::HTTP.delete}.
* Added {Ronin::Support::Network::HTTP.get}.
* Added {Ronin::Support::Network::HTTP.get_headers}.
* Added {Ronin::Support::Network::HTTP.get_cookies}.
* Added {Ronin::Support::Network::HTTP.get_body}.
* Added {Ronin::Support::Network::HTTP.head}.
* Added {Ronin::Support::Network::HTTP.lock}.
* Added {Ronin::Support::Network::HTTP.mkcol}.
* Added {Ronin::Support::Network::HTTP.move}.
* Added {Ronin::Support::Network::HTTP.options}.
* Added {Ronin::Support::Network::HTTP.allowed_methods}.
* Added {Ronin::Support::Network::HTTP.patch}.
* Added {Ronin::Support::Network::HTTP.post}.
* Added {Ronin::Support::Network::HTTP.post_headers}.
* Added {Ronin::Support::Network::HTTP.post_body}.
* Added {Ronin::Support::Network::HTTP.propfind}.
* Added {Ronin::Support::Network::HTTP.proppatch}.
* Added {Ronin::Support::Network::HTTP.put}.
* Added {Ronin::Support::Network::HTTP.trace}.
* Added {Ronin::Support::Network::HTTP.unlock}.
* Added {Ronin::Support::Network::HTTP::Cookie}.
* Added {Ronin::Support::Network::HTTP::Mixin}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_connect}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_connect_uri}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_response_status}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_response_headers}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_server_header}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_powered_by_header}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_response_body}.
* Added {Ronin::Support::Network::HTTP::Mixin#http_patch}.
* Added {Ronin::Support::Network::IP}.
* Added {Ronin::Support::Network::IP::Mixin}.
* Added {Ronin::Support::Network::IP::Mixin#public_address}.
* Added {Ronin::Support::Network::IP::Mixin#public_ip}.
* Added {Ronin::Support::Network::IP::Mixin#local_addresses}.
* Added {Ronin::Support::Network::IP::Mixin#local_address}.
* Added {Ronin::Support::Network::IP::Mixin#local_ips}.
* Added {Ronin::Support::Network::IP::Mixin#local_ip}.
* Added {Ronin::Support::Network::IPRange}.
* Added {Ronin::Support::Network::IPRange::CIDR}.
* Added {Ronin::Support::Network::IPRange::Glob}.
* Added {Ronin::Support::Network::IPRange::Range}.
* Added {Ronin::Support::Network::Mixin}.
* Added {Ronin::Support::Network::PublicSuffix}.
* Added {Ronin::Support::Network::PublicSuffix::List}.
* Added {Ronin::Support::Network::SSL.context}.
* Added {Ronin::Support::Network::SSL::Proxy#version}.
* Added {Ronin::Support::Network::TCP}.
* Added {Ronin::Support::Network::TLD}.
* Added {Ronin::Support::Network::TLD::List}.
* Added {Ronin::Support::Network::TLS}.
* Added {Ronin::Support::Network::TLS::Proxy}.
* Added {Ronin::Support::Network::UDP}.
* Added {Ronin::Support::Text}.
* Added {Ronin::Support::Text::Entropy}.
* Added {Ronin::Support::Text::Homoglyph}.
* Added {Ronin::Support::Text::Homoglyph::Table}.
* Added {Ronin::Support::Text::Patterns::SSH_PRIVATE_KEY}.
* Added {Ronin::Support::Text::Patterns::DSA_PRIVATE_KEY}.
* Added {Ronin::Support::Text::Patterns::EC_PRIVATE_KEY}.
* Added {Ronin::Support::Text::Patterns::RSA_PRIVATE_KEY}.
* Added {Ronin::Support::Text::Patterns::PRIVATE_KEY}.
* Added {Ronin::Support::Text::Patterns::AWS_ACCESS_KEY_ID}.
* Added {Ronin::Support::Text::Patterns::AWS_SECRET_ACCESS_KEY}.
* Added {Ronin::Support::Text::Patterns::API_KEY}.
* Added {Ronin::Support::Text::Patterns::MD5}.
* Added {Ronin::Support::Text::Patterns::SHA1}.
* Added {Ronin::Support::Text::Patterns::SHA256}.
* Added {Ronin::Support::Text::Patterns::SHA512}.
* Added {Ronin::Support::Text::Patterns::HASH}.
* Added {Ronin::Support::Text::Patterns::PUBLIC_KEY}.
* Added {Ronin::Support::Text::Patterns::SSH_PUBLIC_KEY}.
* Added {Ronin::Support::Text::Patterns::DIR_NAME}.
* Added {Ronin::Support::Text::Patterns::MAC_ADDR}.
* Added {Ronin::Support::Text::Patterns::IPV4_ADDR}.
* Added {Ronin::Support::Text::Patterns::IPV6_ADDR}.
* Added {Ronin::Support::Text::Patterns::IP_ADDR}.
* Added {Ronin::Support::Text::Patterns::PUBLIC_SUFFIX}.
* Added {Ronin::Support::Text::Patterns::DOMAIN}.
* Added {Ronin::Support::Text::Patterns::URI}.
* Added {Ronin::Support::Text::Patterns::URL}.
* Added {Ronin::Support::Text::Patterns::NUMBER}.
* Added {Ronin::Support::Text::Patterns::HEX_NUMBER}.
* Added {Ronin::Support::Text::Patterns::VERSION_NUMBER}.
* Added {Ronin::Support::Text::Patterns::EMAIL_ADDRESS}.
* Added {Ronin::Support::Text::Patterns::OBFUSCATED_EMAIL_AT}.
* Added {Ronin::Support::Text::Patterns::OBFUSCATED_EMAIL_DOT}.
* Added {Ronin::Support::Text::Patterns::OBFUSCATED_EMAIL_ADDRESS}.
* Added {Ronin::Support::Text::Patterns::SSN}.
* Added {Ronin::Support::Text::Patterns::AMEX_CC}.
* Added {Ronin::Support::Text::Patterns::DISCOVER_CC}.
* Added {Ronin::Support::Text::Patterns::MASTERCARD_CC}.
* Added {Ronin::Support::Text::Patterns::VISA_CC}.
* Added {Ronin::Support::Text::Patterns::VISA_MASTERCARD_CC}.
* Added {Ronin::Support::Text::Patterns::CC}.
* Added {Ronin::Support::Text::Patterns::VARIABLE_NAME}.
* Added {Ronin::Support::Text::Patterns::VARIABLE_ASSIGNMENT}.
* Added {Ronin::Support::Text::Patterns::FUNCTION_NAME}.
* Added {Ronin::Support::Text::Patterns::DOUBLE_QUOTED_STRING}.
* Added {Ronin::Support::Text::Patterns::SINGLE_QUOTED_STRING}.
* Added {Ronin::Support::Text::Patterns::STRING}.
* Added {Ronin::Support::Text::Patterns::BASE64}.
* Added {Ronin::Support::Text::Patterns::C_STYLE_COMMENT}.
* Added {Ronin::Support::Text::Patterns::C_COMMENT}.
* Added {Ronin::Support::Text::Patterns::CPP_COMMENT}.
* Added {Ronin::Support::Text::Patterns::JAVA_COMMENT}.
* Added {Ronin::Support::Text::Patterns::JAVASCRIPT_COMMENT}.
* Added {Ronin::Support::Text::Patterns::SHELL_STYLE_COMMENT}.
* Added {Ronin::Support::Text::Patterns::SHELL_COMMENT}.
* Added {Ronin::Support::Text::Patterns::BASH_COMMENT}.
* Added {Ronin::Support::Text::Patterns::RUBY_COMMENT}.
* Added {Ronin::Support::Text::Patterns::PYTHON_COMMENT}.
* Added {Ronin::Support::Text::Patterns::COMMENT}.
* Added {Ronin::Support::Text::Random}.
* Added {Ronin::Support::Text::Random::Mixin}.
* Added {Ronin::Support::Text::Typo}.
* Added {Ronin::Support::Text::Typo::Generator}.
* Moved all `Ronin::` constants into the {Ronin::Support} namespace.
* Moved `ronin/support/formatting/digest` core-ext methods into
  `ronin/support/crypto`.
* Renamed `ronin/support/formatting` to `ronin/support/encoding`.
* Renamed `Ronin::Support::Binary::Hexdump::Parser` to
  {Ronin::Support::Binary::Unhexdump::Parser}.
* Merged `ronin/support/network/network` into `ronin/support/network`.
* Removed the `data_paths` gem dependency.
* Removed the `parameters` gem dependency.
* Removed the `yard-parameters` gem dependency.
* Removed `ronin/support/inflector`.
* Removed `Integer#bytes`.
* Removed `Array#bytes` and `Array#chars` in favor of
  {Ronin::Support::Binary::CString}.
* Removed the `probability:` keyword argument from {String#random_case}.
* Removed `udp_single_server` in favor of
  {Ronin::Support::Network::UDP::Mixin#udp_recv udp_recv}.
* Removed `tcp_single_server` in favor of
  {Ronin::Support::Network::TCP::Mixin#tcp_accept tcp_accept}.
* Removed `String#format_uri`.
* Removed `String#format_uri_form`.
* Removed `Integer#format_js`.
* Removed `String#format_js`.
* Removed `Integer#format_http`.
* Removed `String#format_http.
* Removed `Integer#format_xml`.
* Removed `String#format_xml.
* Removed `Integer#format_html`.
* Removed `String#format_html.
* Removed `Integer#format_c`.
* Removed `String#format_c.
* Removed `Ronin::Support::Network::IP.each` and
  `Ronin::Support::Network::IP#each` in favor of
  {Ronin::Support::Network::IPRange}.
* Removed `Resolv.resolver` in favor of {Ronin::Support::Network::DNS.resolver}.
* Removed `Ronin::Support::Network::Telnet.default_prompt`.
* Removed `Ronin::Support::Network::Telnet.default_port`.
* Removed `Ronin::Support::Network::SMTP.default_port`.
* Removed `Ronin::Support::Network::POP3.default_port`.
* Removed `Ronin::Support::Network::IMAP.default_port`.
* Removed `Ronin::Support::Network::FTP.default_port`.
* Removed `Ronin::Support::Network::HTTP::Proxy` value object.
* Removed verbose, normal, quiet, and silent printing modes from
  {Ronin::Support::CLI::Printing}.
* Removed `Ronin::Support::CLI::Printing.format`.
* Removed `Ronin::Support::CLI::Printing#print_exception`.
* Removed `ronin/spec/cli/printing`.
* Removed `Ronin::UI::Output` in favor of {Ronin::Support::CLI::Printing}.
* Removed `Ronin::Wordlist` in favor of the [wordlist] gem.
* Removed `Ronin::UI::REPL` in favor of `Ronin::Core::CLI::Shell` in the
  [ronin-core] gem.
* Removed `Ronin::UI::Shell` in favor of `Ronin::Core::CLI::Shell` in the
  [ronin-core] gem.
* Removed `Ronin::Network::Mixins` in favor of separate `Mixin` modules for each
  {Ronin::Support::Network} module.
* Removed `Net` core-exts.
* Removed `Ronin::Support::Binary::Template.translate`.
* Removed `Ronin::Templates` in favor of {Ronin::Support::Text::ERB}.
* Removed `ssl_server` and `ssl_server_session` in favor of
  {Ronin::Support::Network::SSL::Mixin#ssl_server_socket ssl_server_socket}.
* Removed `String#depack` in favor of overriding {String#unpack}.
* Also override {String#unpack1} to match the functionality of {String#unpack}.

[wordlist]: https://github.com/postmodern/wordlist.rb#readme
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme

### 0.5.2 / 2021-02-28

* Support Ruby 3.0:
  * Temporarily added the [net-telnet] gem as a dependency, since Ruby 3.0 moved
    `net/telnet` out of the stdlib.
  * `Ronin::Fuzzing::SHORT_LENGTHS` and `Ronin::Fuzzing::LONG_LENGTHS` are now
    `Set` objects, instead of `SortedSet`, which Ruby 3.0 moved out of stdlib.
  * Use `URI::DEFAULT_PARSER.escape` / `.unescape` in {String#uri_encode},
    {String#uri_decode}, and {Integer#uri_encode} now that `URI.encode`,
    `URI.decode`, `URI.escape`, `URI.unescape` have all been removed in
    Ruby 3.0.
* Deprecated `Ronin::Network::Telnet`.
* Allow `Ronin::Path#initialize` to accept a separator argument.
* No longer bind new sockets to `0.0.0.0` by default in `Ronin::Network::TCP`
  and `Ronin::Network::UDP`. `0.0.0.0` is the IPv4 Any address, which makes the
  socket IPv4 and thus incompatible with IPv6 hosts.
* Fixed a bug in `Ronin::Network::UDP#udp_open?` where it would always timeout
  and return `nil`, even when the UDP port was open.
* Filter out `nil` or empty `:query` options passed to
  `Ronin::Network::HTTP.request`.
* No longer append the query String to the path in
  `Ronin::Network::HTTP.expand_url`.
* Support escaping `"\`"` tick-marks in `String#sql_escape`.
* Allow setting the request body or form-data in `Ronin::Network::HTTP.request`,
  even for request types that typically do not use a body or form-data.

[net-telnet]: https://github.com/ruby/net-telnet

### 0.5.1 / 2012-06-29

* Added `Ronin::Binary::Template#inspect`.
* Added the `:passive` option to `Ronin::Network::FTP#ftp_connect`.
* Forgot to require `ronin/formatting/extensions/binary/array`.
* Fixed a bug where {Array#pack} would not accept tuples (ex: `[:uint8, 2]`).
* Fixed a bug in `String#sql_decode` where `"\\'\\'"` would incorrectly be
  converted to `'"'`.
* Ensure that {Integer#pack} only accepts one argument.
* Have {String#hex_unescape} to decode every two characters.
* Enable passive-mode by default in `Ronin::Network::FTP#ftp_connect`.

### 0.5.0 / 2012-06-16

* Require uri-query_params ~> 0.6.
* Added {Float#pack}.
* Added `Regexp::WORD`.
* Added `Regexp::PHONE_NUMBER`.
* Added `Ronin::Binary::Template`.
* Added `Ronin::Binary::Struct`.
* Added `Ronin::Binary::Hexdump::Parser`.
* Added `Ronin::Fuzzing::Template`.
* Added `Ronin::Fuzzing::Repeater`.
* Added `Ronin::Fuzzing::Fuzzer`.
* Added `Ronin::Fuzzing::Mutator`.
* Added `Ronin::Wordlist.create`.
* Added `Ronin::Wordlist#path` and `Ronin::Wordlist#words`.
* Added `Ronin::Wordlist#save`.
* Added `Ronin::Network::Proxy`, `Ronin::Network::TCP::Proxy` and
  `Ronin::Network::UDP::Proxy`.
* Added `Ronin::Network::TCP#tcp_open?`.
* Added `Ronin::Network::TCP#tcp_server_loop`.
* Added `Ronin::Network::UDP#udp_open?`.
* Added `Ronin::Network::UDP#udp_server_loop`.
* Added `Ronin::Network::Mixins::TCP#tcp_open?`.
* Added `Ronin::Network::Mixins::UDP#udp_open?`.
* Added `Ronin::Network::Mixins::UDP#udp_server_loop`.
* Added `Ronin::Network::Mixins::UDP#udp_recv`.
* Added `Ronin::Network::FTP`.
* Added `Ronin::Network::UNIX`.
* Added `Ronin::Network::Mixins::FTP`.
* Added `Ronin::Network::Mixins::UNIX`.
* Aliased {String#escape} to `String#dump`.
* Renamed {String#hex_unescape} to {String#unescape}.
  * Aliased {String#hex_unescape} to {String#unescape}.
* Renamed `Ronin::Network::TCP#tcp_single_server` to
  `Ronin::Network::TCP#tcp_accept`.
* Renamed `Ronin::Network::UDP#udp_single_server` to
  `Ronin::Network::UDP#udp_recv`.
* Deprecated `Ronin::Network::TCP#tcp_single_server`.
* Deprecated `Ronin::Network::UDP#udp_single_server`.
* Backported Ruby 1.9 only `Base64` methods.
* Allow {Integer#pack} to accept a type from `Ronin::Binary::Template::TYPES`.
* Allow {Array#pack} to accept types from `Ronin::Binary::Template::TYPES`.
* Allow {String#unpack} to accept types from `Ronin::Binary::Template::TYPES`.
* Support nmap-style `i,j-k` globbed IP address ranges in {IPAddr.each}.
* Moved {String#unhexdump} logic into `Ronin::Binary::Hexdump::Parser`.
  * Added the `:named_chars` option.
  * Improved the parsing of `od` hexdumps.
  * Support unhexdumping specific endianness.
  * Support unhexdumping floats / doubles.
* Allow `String#mutate` to accept Symbols that map to `Ronin::Fuzzing`
  generator methods.
* `Ronin::Fuzzing.[]` now raises a `NoMethodError` for unknown fuzzing methods.
* Use `module_function` in `Ronin::Fuzzing`, so the generator methods can be
  included into other Classes/Modules.
* Use `$stdout` instead of calling `Kernel.puts` or `STDOUT`.
  Prevents infinite recursion if another library overrides `Kernel.puts`.
* Allow `Ronin::Network::DNS` methods to yield resolved addresses.
* Inject `Ronin::Network::DNS` into `Net` for backwards compatibility.
* Allow `Ronin::Network::TCP#tcp_server` to accept a `backlog` argument.
* Default the server host to `0.0.0.0` in
  `Ronin::Network::TCP#tcp_accept`.
* No longer honor the `VERBOSE` environment variable for enabling verbose output
  in `Ronin::UI::Output`. Use `ruby -w` or `ruby -d` instead.
* No longer support loading `extlib` in `ronin/support/inflector`.

### 0.4.0 / 2012-02-12

* Require uri-query_params ~> 0.6.
* Require parameters ~> 0.4.
* Added `Regexp::DELIM`.
* Added `Regexp::IDENTIFIER`.
* Added `Regexp::OCTET`.
* Added `Regexp::FILE_EXT`.
* Added `Regexp::FILE_NAME`.
* Added `Regexp::FILE`.
* Added `Regexp::DIRECTORY`.
* Added `Regexp::RELATIVE_UNIX_PATH`.
* Added `Regexp::ABSOLUTE_UNIX_PATH`.
* Added `Regexp::UNIX_PATH`.
* Added `Regexp::RELATIVE_WINDOWS_PATH`.
* Added `Regexp::ABSOLUTE_WINDOWS_PATH`.
* Added `Regexp::WINDOWS_PATH`.
* Added `Regexp::RELATIVE_PATH`.
* Added `Regexp::ABSOLUTE_PATH`.
* Added `Regexp::PATH`.
* Added `String#repeating`.
* Added `String#sql_inject`.
* Added `String#mutate`.
* Added `Ronin::Fuzzing`.
  * Added `Ronin::Fuzzing.[]`.
  * Added `Ronin::Fuzzing.bad_strings`.
  * Added `Ronin::Fuzzing.format_strings`.
  * Added `Ronin::Fuzzing.bad_paths`.
  * Added `Ronin::Fuzzing.bit_fields`.
  * Added `Ronin::Fuzzing.signed_bit_fields`.
  * Added `Ronin::Fuzzing.uint8`.
  * Added `Ronin::Fuzzing.uint16`.
  * Added `Ronin::Fuzzing.uint32`.
  * Added `Ronin::Fuzzing.uint64`.
  * Added `Ronin::Fuzzing.int8`.
  * Added `Ronin::Fuzzing.int16`.
  * Added `Ronin::Fuzzing.int32`.
  * Added `Ronin::Fuzzing.int64`.
  * Added `Ronin::Fuzzing.sint8`.
  * Added `Ronin::Fuzzing.sint16`.
  * Added `Ronin::Fuzzing.sint32`.
  * Added `Ronin::Fuzzing.sint64`.
* Added `Ronin::Wordlist`.
* Added `Ronin::Network::DNS`.
* Added `Ronin::Network::Mixins::Mixin`.
* Added `Ronin::Network::Mixins::DNS`.
* Added `Ronin::Network::Mixins::SSL`.
* Added missing `Ronin::Network::UDP#udp_send` and
  `Ronin::Network::Mixins::UDP#udp_send` methods.
* Added `Ronin::UI::Output::Helpers#print_exception`.
* Made `Regexp::HOST_NAME` case-insensitive.
* Refactored `Regexp::IPv4` to not match invalid IPv4 addresses.
* Require `ronin/formatting/html` in `ronin/formatting`.
* Allow {String#base64_encode} and {String#base64_decode} to accept a formatting
  argument.
  * `:normal`
  * `:strict`
  * `:url` / `:urlsafe`
* Fixed a bug in {String#js_unescape}, where `%uXX` chars were not being
  unescaped (thanks isis!).
* Have `String#fuzz` only accept `Regexp` and `String` objects.
* Moved `String#fuzz` and `String.generate` into `ronin/fuzzing`.
* Moved `Net.*` methods into the `Ronin::Network` modules.
* Fixed bugs in `Ronin::Network::UDP#udp_connect` and
  `Ronin::Network::UDP#udp_server`.
* Fixed a bug in `Ronin::Network::HTTP.expand_url`, where the URI query-string
  was not being escaped.
* Allow `Ronin::Network::HTTP.request` to accept `:query` and `:query_params`
  options.
* Fixed a bug in `Ronin::Network::Mixins::HTTP#http_session`, where
  normalized options were not being yielded.
* `Ronin::Network::HTTP#http_get_headers` and
  `Ronin::Network::HTTP#http_post_headers` now return a Hash of Capitalized
  Header names and String values.
* Allow `Ronin::Templates::Erb` to use `<%- -%>` syntax.
* Alias `<<` to `write` in `Ronin::UI::Output::Helpers`.
* Fixed bugs in `Ronin::UI::Shell`.
* Warning messages are printed by `Ronin::UI::Output::Helpers`, unless output
  is silenced.
* `Ronin::UI::Output::Helpers` and `Ronin::Network` modules are included into
  `Ronin::Support`.

### 0.3.0 / 2011-10-16

* Require combinatorics ~> 0.4.
* Added {Enumerable#map_hash}.
* Added `String.generate`.
* Added `String#fuzz`.
* Added {File.each_line}.
* Added {File.each_row}.
* Added `Resolv.resolver`.
* Added `URI::HTTP#request`.
* Added {URI::HTTP#status}.
* Added {URI::HTTP#ok?}.
* Added `URI::HTTP#server`.
* Added `URI::HTTP#powered_by`.
* Added `URI::HTTP#copy`.
* Added `URI::HTTP#delete`.
* Added `URI::HTTP#get`.
* Added `URI::HTTP#get_headers`.
* Added `URI::HTTP#get_body`.
* Added `URI::HTTP#head`.
* Added `URI::HTTP#lock`.
* Added `URI::HTTP#mkcol`.
* Added `URI::HTTP#move`.
* Added `URI::HTTP#options`.
* Added `URI::HTTP#post`.
* Added `URI::HTTP#post_headers`.
* Added `URI::HTTP#post_body`.
* Added `URI::HTTP#prop_find`.
* Added `URI::HTTP#prop_match`.
* Added `URI::HTTP#trace`.
* Added `URI::HTTP#unlock`.
* Added `Regexp::MAC`.
* Added `Regexp::IPv6`, `Regexp::IPv4` and `Regexp::IP`.
* Added `Regexp::HOST_NAME`.
* Added `Regexp::USER_NAME`.
* Added `Regexp::EMAIL_ADDR`.
* Moved `Ronin::UI::Output`, `Ronin::UI::Shell` and `Ronin::Network::Mixins`
  from ronin into ronin-support.
* Refactored `Ronin::UI::Shell` into a Class where commands are defined as
  protected methods.

### 0.2.0 / 2011-07-04

* Require data_paths ~> 0.3.
* Added `Ronin::Mixin`.
* Added `Ronin::Network::SMTP::Email#headers`.
* Added {Integer#html_escape}.
* Added {Integer#js_escape}.
* Added `Integer#format_js`.
* Added {String#html_escape}.
* Added {String#html_unescape}.
* Added {String#js_escape}.
* Added {String#js_unescape}.
* Added `String#format_js`.
* Added `Net.smtp_send_message`.
* Added `Net.http_status`.
* Added `Net.http_get_headers`.
* Added `Net.http_post_headers`.
* Added YARD `@api` tags to define the public, semi-public and private APIs.
* Renamed `Kernel#attempt` to {Kernel#try}.
* Allow `:method` to be used with `Net.http_ok?`.
* Fixed a bug in `Ronin::Network::HTTP.expand_url` where `:host` and `:port`
  options were being overridden.
* Improved the performance of `Integer#bytes`.
* Only redefine `String#dump` for Ruby 1.8.x.
  * Ruby >= 1.9.1 correctly hex-escapes special characters.
* Fixed a bug in `String#format_chars`, where it was not using `each_char`
  for unicode characters.
* Deprecated `String#common_postfix`, in favor of {String#common_suffix}.
  `String#common_postfix` will be removed in ronin-support 1.0.0.
* `Net.http_get_body` no longer accepts a block.
* `Net.http_post_body` no longer accepts a block.

### 0.1.0 / 2011-03-20

* Initial release:
  * Split out of [ronin](http://github.com/ronin-rb/ronin) 0.3.0.
  * Upgraded to the LGPL-3 license.
  * Require Ruby >= 1.8.7.
  * Require chars ~> 0.2.
  * Require combinatorics ~> 0.3.
  * Require uri-query_params ~> 0.5, >= 0.5.2.
  * Require data_paths ~> 0.2, >= 0.2.1.
