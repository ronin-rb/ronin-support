require 'static_paths'

module Helpers
  include StaticPaths

  STATIC_TEMPLATE_DIR = File.expand_path(File.join(File.dirname(__FILE__),'static'))

  register_static_dir STATIC_TEMPLATE_DIR
end
