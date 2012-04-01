source 'https://rubygems.org'

gemspec

platforms :jruby do
  gem 'jruby-openssl',	'~> 0.7.0'
end

group :development do
  gem 'rake',		        '~> 0.8'

  gem 'ore-tasks',	    '~> 0.4'
  gem 'rspec',          '~> 2.8'

  gem 'kramdown',       '~> 0.12'
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
