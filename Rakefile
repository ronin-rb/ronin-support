require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require './lib/ronin/support/version.rb'

Jeweler::Tasks.new do |gem|
  gem.name = 'ronin-support'
  gem.version = Ronin::Support::VERSION
  gem.licenses = ['LGPL-2.1']
  gem.summary = %Q{A support library for Ronin.}
  gem.description = %Q{Ronin Support is a support library for Ronin. Ronin EXT contains many of the convenience methods used by Ronin and additional libraries.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = 'http://github.com/ronin-ruby/ronin-support'
  gem.authors = ['Postmodern']
  gem.has_rdoc = 'yard'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
