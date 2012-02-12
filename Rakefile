require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'ore/tasks'
Ore::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

namespace :spec do
  RSpec::Core::RakeTask.new(:network) do |t|
    t.pattern    = 'spec/network/{**/}*_spec.rb'
    t.rspec_opts = '--tag network'
  end
end

task :test => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
task :docs => :yard
