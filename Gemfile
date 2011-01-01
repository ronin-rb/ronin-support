source 'https://rubygems.org'

gemspec

platforms :jruby do
  gem 'jruby-openssl',	'~> 0.7.0'
end

group :development do
  gem 'rake',		        '~> 0.8.7'

  platforms :jruby do
    gem 'BlueCloth'
  end

  platforms :ruby do
    gem 'rdiscount',    '~> 1.6.3'
  end

  gem 'ore-core',       '~> 0.1.0'
  gem 'ore-tasks',	    '~> 0.2.0'
  gem 'rspec',          '~> 2.0.0'
end
