source 'https://rubygems.org'

gemspec

platforms :jruby do
  gem 'jruby-openssl',	'~> 0.7'
end

group :development do
  gem 'rake',               '~> 0.8'
  gem 'rubygems-tasks',     '~> 0.1.0.pre1'
  gem 'ripl',               '~> 0.3'
  gem 'ripl-multi_line',    '~> 0.2'
  gem 'ripl-auto_indent',   '~> 0.1'
  gem 'ripl-color_result',  '~> 0.3'
  gem 'rspec',              '~> 2.8'
  gem 'kramdown',           '~> 0.12'
end

group :test do
  gem 'i18n',           '~> 0.4'
  gem 'tzinfo',         '~> 0.3'

  INFLECTORS = {
    'activesupport' => '~> 3.0',
    'dm-core'       => '~> 1.0',
    'extlib'        => '~> 0.9'
  }

  inflector = ENV.fetch('INFLECTOR','dm-core')
  gem(inflector,INFLECTORS[inflector])
end
