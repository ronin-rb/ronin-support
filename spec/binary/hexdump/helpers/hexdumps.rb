module Helpers
  DIRECTORY = File.join(File.dirname(__FILE__),'hexdumps')

  def load_binary_data(name)
    File.open(File.join(DIRECTORY,"#{name}.bin"),'rb') do |file|
      file.read
    end
  end

  def load_hexdump(name)
    File.read(File.join(DIRECTORY,"#{name}.txt"))
  end
end
