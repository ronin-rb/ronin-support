require 'ronin/templates/template'

class ExampleTemplate

  include Ronin::Templates::Template

  def enter_example_template(&block)
    enter_template(File.join('templates','example.erb'),&block)
  end

  def enter_relative_template(&block)
    enter_template(File.join('templates','example.erb')) do |path|
      enter_template(File.join('..','includes','_relative.erb'),&block)
    end
  end

  def enter_missing_template(&block)
    enter_template('totally_missing.erb',&block)
  end

  def read_example_template(&block)
    read_template(File.join('templates','example.erb'),&block)
  end

  def read_relative_template(&block)
    read_template(File.join('templates','example.erb')) do |contents|
      read_template(File.join('..','includes','_relative.erb'),&block)
    end
  end

  def read_missing_template(&block)
    read_template('totally_missing.erb',&block)
  end

end
