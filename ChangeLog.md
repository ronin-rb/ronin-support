### 0.5.0 / 2012-06-16

* Require uri-query_params ~> 0.6.
* Added {Float#pack}.
* Added {Regexp::WORD}.
* Added {Regexp::PHONE_NUMBER}.
* Added {Ronin::Binary::Template}.
* Added {Ronin::Binary::Struct}.
* Added {Ronin::Binary::Hexdump::Parser}.
* Added {Ronin::Fuzzing::Template}.
* Added {Ronin::Fuzzing::Repeater}.
* Added {Ronin::Fuzzing::Fuzzer}.
* Added {Ronin::Fuzzing::Mutator}.
* Added {Ronin::Wordlist.create}.
* Added {Ronin::Wordlist#path} and {Ronin::Wordlist#words}.
* Added {Ronin::Wordlist#save}.
* Added {Ronin::Network::Proxy}, {Ronin::Network::TCP::Proxy} and
  {Ronin::Network::UDP::Proxy}.
* Added {Ronin::Network::TCP#tcp_open?}.
* Added {Ronin::Network::TCP#tcp_server_loop}.
* Added {Ronin::Network::UDP#udp_open?}.
* Added {Ronin::Network::UDP#udp_server_loop}.
* Added {Ronin::Network::Mixins::TCP#tcp_open?}.
* Added {Ronin::Network::Mixins::UDP#udp_open?}.
* Added {Ronin::Network::Mixins::UDP#udp_server_loop}.
* Added {Ronin::Network::Mixins::UDP#udp_recv}.
* Added {Ronin::Network::FTP}.
* Added {Ronin::Network::UNIX}.
* Added {Ronin::Network::Mixins::FTP}.
* Added {Ronin::Network::Mixins::UNIX}.
* Aliased {String#escape} to {String#dump}.
* Renamed {String#hex_unescape} to {String#unescape}.
  * Aliased {String#hex_unescape} to {String#unescape}.
* Renamed {Ronin::Network::TCP#tcp_single_server} to
  {Ronin::Network::TCP#tcp_accept}.
* Renamed {Ronin::Network::UDP#udp_single_server} to
  {Ronin::Network::UDP#udp_recv}.
* Deprecated {Ronin::Network::TCP#tcp_single_server}.
* Deprecated {Ronin::Network::UDP#udp_single_server}.
* Backported Ruby 1.9 only {Base64} methods.
* Allow {Integer#pack} to accept a type from {Ronin::Binary::Template::TYPES}.
* Allow {Array#pack} to accept types from {Ronin::Binary::Template::TYPES}.
* Allow {String#unpack} to accept types from {Ronin::Binary::Template::TYPES}.
* Support nmap-style `i,j-k` globbed IP address ranges in {IPAddr.each}.
* Moved {String#unhexdump} logic into {Ronin::Binary::Hexdump::Parser}.
  * Added the `:named_chars` option.
  * Improved the parsing of `od` hexdumps.
  * Support unhexdumping specific endianness.
  * Support unhexdumping floats / doubles.
* Allow {String#mutate} to accept Symbols that map to {Ronin::Fuzzing}
  generator methods.
* {Ronin::Fuzzing.[]} now raises a `NoMethodError` for unknown fuzzing methods.
* Use `module_function` in {Ronin::Fuzzing}, so the generator methods can be
  included into other Classes/Modules.
* Use `$stdout` instead of calling `Kernel.puts` or `STDOUT`.
  Prevents infinite recursion if another library overrides `Kernel.puts`.
* Allow {Ronin::Network::DNS} methods to yield resolved addresses.
* Inject {Ronin::Network::DNS} into {Net} for backwards compatibility.
* Allow {Ronin::Network::TCP#tcp_server} to accept a `backlog` argument.
* Default the server host to `0.0.0.0` in
  {Ronin::Network::TCP#tcp_accept}.
* No longer honor the `VERBOSE` environment variable for enabling verbose output
  in {Ronin::UI::Output}. Use `ruby -w` or `ruby -d` instead.
* No longer support loading `extlib` in `ronin/support/inflector`.

### 0.4.0 / 2012-02-12

* Require uri-query_params ~> 0.6.
* Require parameters ~> 0.4.
* Added {Regexp::DELIM}.
* Added {Regexp::IDENTIFIER}.
* Added {Regexp::OCTET}.
* Added {Regexp::FILE_EXT}.
* Added {Regexp::FILE_NAME}.
* Added {Regexp::FILE}.
* Added {Regexp::DIRECTORY}.
* Added {Regexp::RELATIVE_UNIX_PATH}.
* Added {Regexp::ABSOLUTE_UNIX_PATH}.
* Added {Regexp::UNIX_PATH}.
* Added {Regexp::RELATIVE_WINDOWS_PATH}.
* Added {Regexp::ABSOLUTE_WINDOWS_PATH}.
* Added {Regexp::WINDOWS_PATH}.
* Added {Regexp::RELATIVE_PATH}.
* Added {Regexp::ABSOLUTE_PATH}.
* Added {Regexp::PATH}.
* Added {String#repeating}.
* Added {String#sql_inject}.
* Added {String#mutate}.
* Added {Ronin::Fuzzing}.
  * Added {Ronin::Fuzzing.[]}.
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
* Added {Ronin::Wordlist}.
* Added {Ronin::Network::DNS}.
* Added {Ronin::Network::Mixins::Mixin}.
* Added {Ronin::Network::Mixins::DNS}.
* Added {Ronin::Network::Mixins::SSL}.
* Added missing {Ronin::Network::UDP#udp_send} and
  {Ronin::Network::Mixins::UDP#udp_send} methods.
* Added {Ronin::UI::Output::Helpers#print_exception}.
* Made {Regexp::HOST_NAME} case-insensitive.
* Refactored {Regexp::IPv4} to not match invalid IPv4 addresses.
* Require `ronin/formatting/html` in `ronin/formatting`.
* Allow {String#base64_encode} and {String#base64_decode} to accept a formatting
  argument.
  * `:normal`
  * `:strict`
  * `:url` / `:urlsafe`
* Fixed a bug in {String#js_unescape}, where `%uXX` chars were not being
  unescaped (thanks isis!).
* Have {String#fuzz} only accept `Regexp` and `String` objects.
* Moved {String#fuzz} and {String.generate} into `ronin/fuzzing`.
* Moved `Net.*` methods into the {Ronin::Network} modules.
* Fixed bugs in {Ronin::Network::UDP#udp_connect} and
  {Ronin::Network::UDP#udp_server}.
* Fixed a bug in {Ronin::Network::HTTP.expand_url}, where the URI query-string
  was not being escaped.
* Allow {Ronin::Network::HTTP.request} to accept `:query` and `:query_params`
  options.
* Fixed a bug in `Ronin::Network::Mixins::HTTP#http_session`, where
  normalized options were not being yielded.
* {Ronin::Network::HTTP#http_get_headers} and
  {Ronin::Network::HTTP#http_post_headers} now return a Hash of Capitalized
  Header names and String values.
* Allow {Ronin::Templates::Erb} to use `<%- -%>` syntax.
* Alias `<<` to `write` in {Ronin::UI::Output::Helpers}.
* Fixed bugs in {Ronin::UI::Shell}.
* Warning messages are printed by {Ronin::UI::Output::Helpers}, unless output
  is silenced.
* {Ronin::UI::Output::Helpers} and {Ronin::Network} modules are included into
  {Ronin::Support}.

### 0.3.0 / 2011-10-16

* Require combinatorics ~> 0.4.
* Added {Enumerable#map_hash}.
* Added {String.generate}.
* Added {String#fuzz}.
* Added {File.each_line}.
* Added {File.each_row}.
* Added {Resolv.resolver}.
* Added {URI::HTTP#request}.
* Added {URI::HTTP#status}.
* Added {URI::HTTP#ok?}.
* Added {URI::HTTP#server}.
* Added {URI::HTTP#powered_by}.
* Added {URI::HTTP#copy}.
* Added {URI::HTTP#delete}.
* Added {URI::HTTP#get}.
* Added {URI::HTTP#get_headers}.
* Added {URI::HTTP#get_body}.
* Added {URI::HTTP#head}.
* Added {URI::HTTP#lock}.
* Added {URI::HTTP#mkcol}.
* Added {URI::HTTP#move}.
* Added {URI::HTTP#options}.
* Added {URI::HTTP#post}.
* Added {URI::HTTP#post_headers}.
* Added {URI::HTTP#post_body}.
* Added {URI::HTTP#prop_find}.
* Added {URI::HTTP#prop_match}.
* Added {URI::HTTP#trace}.
* Added {URI::HTTP#unlock}.
* Added {Regexp::MAC}.
* Added {Regexp::IPv6}, {Regexp::IPv4} and {Regexp::IP}.
* Added {Regexp::HOST_NAME}.
* Added {Regexp::USER_NAME}.
* Added {Regexp::EMAIL_ADDR}.
* Moved {Ronin::UI::Output}, {Ronin::UI::Shell} and {Ronin::Network::Mixins}
  from ronin into ronin-support.
* Refactored {Ronin::UI::Shell} into a Class where commands are defined as
  protected methods.

### 0.2.0 / 2011-07-04

* Require data_paths ~> 0.3.
* Added {Ronin::Mixin}.
* Added {Ronin::Network::SMTP::Email#headers}.
* Added {Integer#html_escape}.
* Added {Integer#js_escape}.
* Added {Integer#format_js}.
* Added {String#html_escape}.
* Added {String#html_unescape}.
* Added {String#js_escape}.
* Added {String#js_unescape}.
* Added {String#format_js}.
* Added `Net.smtp_send_message`.
* Added `Net.http_status`.
* Added `Net.http_get_headers`.
* Added `Net.http_post_headers`.
* Added YARD `@api` tags to define the public, semi-public and private APIs.
* Renamed `Kernel#attempt` to {Kernel#try}.
* Allow `:method` to be used with `Net.http_ok?`.
* Fixed a bug in {Ronin::Network::HTTP.expand_url} where `:host` and `:port`
  options were being overridden.
* Improved the performance of {Integer#bytes}.
* Only redefine {String#dump} for Ruby 1.8.x.
  * Ruby >= 1.9.1 correctly hex-escapes special characters.
* Fixed a bug in {String#format_chars}, where it was not using `each_char`
  for unicode characters.
* Deprecated {String#common_postfix}, in favor of {String#common_suffix}.
  {String#common_postfix} will be removed in ronin-support 1.0.0.
* `Net.http_get_body` no longer accepts a block.
* `Net.http_post_body` no longer accepts a block.

### 0.1.0 / 2011-03-20

* Initial release:
  * Split out of [ronin](http://github.com/ronin-ruby/ronin) 0.3.0.
  * Upgraded to the LGPL-3 license.
  * Require Ruby >= 1.8.7.
  * Require chars ~> 0.2.
  * Require combinatorics ~> 0.3.
  * Require uri-query_params ~> 0.5, >= 0.5.2.
  * Require data_paths ~> 0.2, >= 0.2.1.

