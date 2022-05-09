require 'rspec'
require_relative 'unix_examples'

shared_examples_for "common BSD types" do
  include_context "common UNIX types"

  {
    :caddr_t => :string,
    :fixpt_t => :uint,
    :__int64_t => :long_long,
    :int64_t => :long_long,
    :off_t => :long_long,
    :qaddr_t => :pointer,
    :quad_t => :long_long,
    :sa_family_t => :uchar,
    :segsz_t => :int,
    :__uint64_t => :ulong_long,
    :u_quad_t => :ulong_long,
    :useconds_t => :uint
  }.each do |typedef_name,type|
    it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
      expect(subject[typedef_name]).to eq(types[type])
    end
  end
end
