source 'https://rubygems.org'

gemspec

gem 'jruby-openssl',	'~> 0.7.0', :platforms => :jruby

group :development do
  gem 'rake'
  gem 'rubygems-tasks',     '~> 0.1'
  gem 'rspec',              '~> 3.0'
  gem 'simplecov',          '~> 0.18'

  gem 'ripl',               '~> 0.3'
  gem 'ripl-multi_line',    '~> 0.2'
  gem 'ripl-auto_indent',   '~> 0.1'
  gem 'ripl-color_result',  '~> 0.3'

  gem 'kramdown',           '~> 2.0'

  gem 'dead_end', require: false
end

group :test do
  case ENV['INFLECTOR']
  when 'activesupport'
    gem 'i18n',           '~> 1.0'
    gem 'tzinfo',         '~> 2.0'
    gem 'activesupport',  '~> 6.0'
  else
    gem 'dm-core',        '~> 1.0'
  end
end
