require 'ronin/ui/shell'

class TestShell < Ronin::UI::Shell

  def a_public_method
  end

  protected

  def command1
    :command1
  end

  def command_with_arg(arg)
    arg
  end

  def command_with_args(*args)
    args
  end

end
