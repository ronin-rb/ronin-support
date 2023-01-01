require 'rspec'

shared_examples_for "common UNIX types" do
  {
    :gid_t => :uint,
    :in_addr_t => :uint,
    :in_port_t => :ushort,
    :__int16_t => :short,
    :int16_t => :short,
    :__int32_t => :int,
    :int32_t => :int,
    :__int8_t => :char,
    :int8_t => :char,
    :pid_t => :int,
    :socklen_t => :uint,
    :u_char => :uchar,
    :uid_t => :uint,
    :__uint16_t => :ushort,
    :u_int16_t => :ushort,
    :__uint32_t => :uint,
    :u_int32_t => :uint,
    :u_int64_t => :ulong_long,
    :__uint8_t => :uchar,
    :u_int8_t => :uchar,
    :u_int => :uint,
    :u_long => :ulong,
    :u_short => :ushort
  }.each do |typedef_name,type|
    it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
      expect(subject[typedef_name]).to eq(types[type])
    end
  end
end
