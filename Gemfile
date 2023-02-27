source 'https://rubygems.org'

gemspec

gem 'jruby-openssl',	'~> 0.7', platforms: :jruby

gem 'net-telnet', '~> 0.1', group: :net
if RUBY_VERSION >= '3.1.0'
  gem 'net-ftp',    '~> 0.1', group: :net
  gem 'net-smtp',   '~> 0.1', group: :net
  gem 'net-pop',    '~> 0.1', group: :net
  gem 'net-imap',   '~> 0.1', group: :net
end

group :development do
  gem 'rake'
  gem 'rubygems-tasks',     '~> 0.1'
  gem 'rspec',              '~> 3.0'
  gem 'webmock',            '~> 3.0'
  gem 'simplecov',          '~> 0.18'

  gem 'kramdown',           '~> 2.0'
  gem 'redcarpet',          platform: :mri
  gem 'yard',               '~> 0.9'
  gem 'yard-spellcheck',    require: false

  gem 'dead_end',           require: false
  gem 'sord',               require: false, platform: :mri
  gem 'stackprof',          require: false, platform: :mri
  gem 'rubocop',            require: false, platform: :mri
  gem 'rubocop-ronin',      require: false, platform: :mri
end
