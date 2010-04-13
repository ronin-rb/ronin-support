require 'rubygems'
require 'rake'
require './lib/ronin/ext/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ronin-ext'
    gem.version = Ronin::EXT::VERSION
    gem.licenses = ['LGPL-2.1']
    gem.summary = %Q{A support library for Ronin.}
    gem.description = %Q{Ronin EXT is a support library for Ronin. Ronin EXT contains many of the convenience methods used by Ronin and additional libraries.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/ronin-ruby/ronin-ext'
    gem.authors = ['Postmodern']
    gem.add_dependency 'chars', '~> 0.1.2'
    gem.add_dependency 'parameters', '~> 0.2.0'
    gem.add_dependency 'data_paths', '~> 0.2.1'
    gem.add_development_dependency 'rspec', '~> 1.3.0'
    gem.add_development_dependency 'yard', '~> 0.5.3'
    gem.add_development_dependency 'yard-parameters', '~> 0.1.0'
    gem.has_rdoc = 'yard'
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
