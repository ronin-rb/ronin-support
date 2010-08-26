source 'https://rubygems.org'

gem 'chars',		'~> 0.1.2'
gem 'data_paths',	'~> 0.2.1'

group(:development) do
  gem 'bundler',		'~> 1.0.0'
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.5.0', :git => 'http://github.com/technicalpickles/jeweler.git'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.5.3'
end

gem 'rspec',	'~> 2.0.0.beta.20', :group => [:development, :test]
