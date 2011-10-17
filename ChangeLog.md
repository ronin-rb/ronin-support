### 0.3.0 / 2011-10-15

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
* Added {Net.smtp_send_message}.
* Added {Net.http_status}.
* Added {Net.http_get_headers}.
* Added {Net.http_post_headers}.
* Added YARD `@api` tags to define the public, semi-public and private APIs.
* Renamed `Kernel#attempt` to {Kernel#try}.
* Allow `:method` to be used with {Net.http_ok?}.
* Fixed a bug in {Ronin::Network::HTTP.expand_url} where `:host` and `:port`
  options were being overridden.
* Improved the performance of {Integer#bytes}.
* Only redefine {String#dump} for Ruby 1.8.x.
  * Ruby >= 1.9.1 correctly hex-escapes special characters.
* Fixed a bug in {String#format_chars}, where it was not using `each_char`
  for unicode characters.
* Deprecated {String#common_postfix}, in favor of {String#common_suffix}.
  {String#common_postfix} will be removed in ronin-support 1.0.0.
* {Net.http_get_body} no longer accepts a block.
* {Net.http_post_body} no longer accepts a block.

### 0.1.0 / 2011-03-20

* Initial release:
  * Split out of [ronin](http://github.com/ronin-ruby/ronin) 0.3.0.
  * Upgraded to the LGPL-3 license.
  * Require Ruby >= 1.8.7.
  * Require chars ~> 0.2.
  * Require combinatorics ~> 0.3.
  * Require uri-query_params ~> 0.5, >= 0.5.2.
  * Require data_paths ~> 0.2, >= 0.2.1.

