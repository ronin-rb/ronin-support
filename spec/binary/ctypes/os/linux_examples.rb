require 'rspec'

require_relative 'unix_examples'

shared_examples_for "common GNU/Linux types" do
  include_context "common UNIX types"

  {
    :__blkcnt_t => :long,
    :__blksize_t => :long,
    :blksize_t => :long,
    :__clockid_t => :int,
    :clockid_t => :int,
    :__clock_t => :long,
    :__daddr_t => :int,
    :daddr_t => :int,
    :__fd_mask => :long,
    :fd_mask => :long,
    :__fsblkcnt_t => :ulong,
    :__fsfilcnt_t => :ulong,
    :__gid_t => :uint,
    :__id_t => :uint,
    :id_t => :uint,
    :__ino_t => :ulong,
    :__key_t => :int,
    :key_t => :int,
    :__mode_t => :uint,
    :mode_t => :uint,
    :__off_t => :long,
    :__pid_t => :int,
    :__priority_which_t => :int,
    :pthread_key_t => :uint,
    :pthread_once_t => :int,
    :pthread_t => :ulong,
    :register_t => :long,
    :__rlimit_resource_t => :int,
    :__rlim_t => :ulong,
    :__rusage_who_t => :int,
    :sa_family_t => :ushort,
    :__sig_atomic_t => :int,
    :__socklen_t => :uint,
    :__suseconds_t => :long,
    :suseconds_t => :long,
    :__timer_t => :pointer,
    :timer_t => :pointer,
    :__time_t => :long,
    :time_t => :long,
    :__u_char => :uchar,
    :__uid_t => :uint,
    :uid_t => :uint,
    :__u_int => :uint,
    :__u_long => :ulong,
    :__useconds_t => :uint,
    :__u_short => :ushort
  }.each do |typedef_name,type|
    it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
      expect(subject[typedef_name]).to eq(types[type])
    end
  end

  it "must define a :__caddr_t -> POINTER typedef" do
    expect(subject[:__caddr_t]).to eq(types::POINTER)
  end
end

shared_examples_for "32bit GNU/Linux types" do
  include_examples "common GNU/Linux types"

  {
    :__blkcnt64_t => :long_long,
    :blkcnt_t => :long_long,
    :__dev_t => :ulong_long,
    :dev_t => :ulong_long,
    :__fsblkcnt64_t => :ulong_long,
    :fsblkcnt_t => :ulong_long,
    :__fsfilcnt64_t => :ulong_long,
    :fsfilcnt_t => :ulong_long,
    :__ino64_t => :ulong_long,
    :ino_t => :ulong_long,
    :__int64_t => :long_long,
    :int64_t => :long_long,
    :__intptr_t => :int,
    :__loff_t => :long_long,
    :loff_t => :long_long,
    :__nlink_t => :uint,
    :nlink_t => :uint,
    :__off64_t => :long_long,
    :off_t => :long_long,
    :__quad_t => :long_long,
    :quad_t => :long_long,
    :__rlim64_t => :ulong_long,
    :rlim_t => :ulong_long,
    :size_t => :uint,
    :__ssize_t => :int,
    :ssize_t => :int,
    :__swblk_t => :long,
    :__uint64_t => :ulong_long,
    :__u_quad_t => :ulong_long,
    :u_quad_t => :ulong_long
  }.each do |typedef_name,type|
    it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
      expect(subject[typedef_name]).to eq(types[type])
    end
  end

  it "must define a :__qaddr_t -> POINTER typedef" do
    expect(subject[:__qaddr_t]).to eq(types::POINTER)
  end
end

shared_examples_for "64bit GNU/Linux types" do
  include_examples "common GNU/Linux types"

  {
    :__blkcnt64_t => :long,
    :blkcnt_t => :long,
    :clock_t => :long,
    :__dev_t => :ulong,
    :dev_t => :ulong,
    :__fsblkcnt64_t => :ulong,
    :fsblkcnt_t => :ulong,
    :__fsfilcnt64_t => :ulong,
    :fsfilcnt_t => :ulong,
    :__fsword_t => :long,
    :__ino64_t => :ulong,
    :ino_t => :ulong,
    :__int64_t => :long,
    :int64_t => :long,
    :int_fast16_t => :long,
    :int_fast32_t => :long,
    :int_fast64_t => :long,
    :int_fast8_t => :char,
    :int_least32_t => :int,
    :int_least64_t => :long,
    :int_least8_t => :char,
    :__intmax_t => :long,
    :intmax_t => :long,
    :__intptr_t => :long,
    :intptr_t => :long,
    :__loff_t => :long,
    :loff_t => :long,
    :__nlink_t => :ulong,
    :nlink_t => :ulong,
    :__off64_t => :long,
    :off_t => :long,
    :ptrdiff_t => :long,
    :__quad_t => :long,
    :quad_t => :long,
    :__rlim64_t => :ulong,
    :rlim_t => :ulong,
    :size_t => :ulong,
    :__ssize_t => :long,
    :ssize_t => :long,
    :__syscall_slong_t => :long,
    :__syscall_ulong_t => :ulong,
    :uint16_t => :ushort,
    :uint32_t => :uint,
    :__uint64_t => :ulong,
    :uint64_t => :ulong,
    :uint8_t => :uchar,
    :uint_fast16_t => :ulong,
    :uint_fast32_t => :ulong,
    :uint_fast64_t => :ulong,
    :uint_fast8_t => :uchar,
    :uint_least16_t => :ushort,
    :uint_least32_t => :uint,
    :uint_least64_t => :ulong,
    :uint_least8_t => :uchar,
    :__uintmax_t => :ulong,
    :uintmax_t => :ulong,
    :uintptr_t => :ulong,
    :__u_quad_t => :ulong,
    :u_quad_t => :ulong,
    :wchar_t => :int
  }.each do |typedef_name,type|
    it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
      expect(subject[typedef_name]).to eq(types[type])
    end
  end
end
