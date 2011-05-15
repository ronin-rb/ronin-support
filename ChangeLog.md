### 0.2.0 / 2011-05-14

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
* Added YARD `@api` tags to define the public, semi-public and private APIs.
* Allow `:method` to be used with {Net.http_ok?}.
* Fixed a bug in {Ronin::Network::HTTP.expand_url} where `:host` and `:port`
  options were being overridden.
* Fixed a bug in {String#format_chars}, where it was not using `each_char`
  for unicode characters.
* Deprecated {String#common_postfix}, in favor of {String#common_suffix}.
  {String#common_postfix} will be removed in ronin-support 1.0.0.

### 0.1.0 / 2011-03-20

* Initial release:
  * Split out of [ronin](http://github.com/ronin-ruby/ronin) 0.3.0.
  * Upgraded to the LGPL-3 license.
  * Require Ruby >= 1.8.7.
  * Require chars ~> 0.2.
  * Require combinatorics ~> 0.3.
  * Require uri-query_params ~> 0.5, >= 0.5.2.
  * Require data_paths ~> 0.2, >= 0.2.1.

