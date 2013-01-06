require 'ronin/behaviors/testable'

class TestableClass

  include Ronin::Behaviors::Testable

  parameter :var

  def initialize(attributes={},&block)
    super(attributes)

    instance_eval(&block) if block
  end

end
