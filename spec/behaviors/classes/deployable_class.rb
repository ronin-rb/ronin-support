require 'ronin/behaviors/deployable'

class DeployableClass

  include Ronin::Behaviors::Deployable

  parameter :var, default: 5

end
