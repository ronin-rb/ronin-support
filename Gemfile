source 'https://rubygems.org'

gem 'combinatorics',	'~> 0.2.0'
gem 'chars',		'~> 0.1.2'
gem 'uri-query_params',	'~> 0.4.0'
gem 'data_paths',	'~> 0.2.1'

group(:development) do
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.5.0.pre'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.6.0'
end

gem 'rspec',	'~> 2.0.0.rc', :group => [:development, :test]
