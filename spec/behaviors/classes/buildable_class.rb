require 'ronin/behaviors/buildable'

class BuildableClass

  include Ronin::Behaviors::Buildable

  parameter :var, default: 'world'

  attr_reader :output

end
