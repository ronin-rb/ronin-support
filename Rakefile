# frozen_string_literal: true

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

require 'rubygems/tasks'
Gem::Tasks.new(sign: {checksum: true, pgp: true})

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

namespace :spec do
  RSpec::Core::RakeTask.new(:network) do |t|
    t.pattern    = 'spec/network/{**/}*_spec.rb'
    t.rspec_opts = '--tag network'
  end
end

task :test    => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
task :docs => :yard

namespace :public_suffix do
  desc 'Downloads the public_suffix_list.dat file'
  task :download do
    require 'ronin/support/network/public_suffix/list'
    Ronin::Support::Network::PublicSuffix::List.download(
      path: 'public_suffix_list.dat'
    )
  end

  desc 'Builds a regex for every public suffix'
  task :build_regex => :download do
    require 'ronin/support/network/public_suffix/list'
    list = Ronin::Support::Network::PublicSuffix::List.load_file(
      'public_suffix_list.dat'
    )

    regex = list.to_regexp

    template = 'data/text/patterns/network/public_suffix.rb.erb'
    output   = 'lib/ronin/support/text/patterns/network/public_suffix.rb'

    require 'erb'
    erb = ERB.new(File.read(template))
    File.write(output,erb.result(binding))
  end
end
