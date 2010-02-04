# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :yard

Hoe.spec('ronin-ext') do
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_title = 'Ronin EXT Documentation'
  self.yard_options += ['--markup', 'markdown', '--protected']
  self.remote_yard_dir = 'docs/ronin-ext'

  self.extra_dev_deps = [
    ['rspec', '>=1.3.0'],
    ['yard', '>=0.5.3']
  ]
end

# vim: syntax=Ruby
