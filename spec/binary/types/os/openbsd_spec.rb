require 'spec_helper'
require 'ronin/support/binary/types/os/openbsd'
require 'ronin/support/binary/types/arch/x86'
require 'ronin/support/binary/types/arch/x86_64'

describe Ronin::Support::Binary::Types::OS::OpenBSD do
  shared_examples_for "common typedefs" do
    {
      :caddr_t => :string,
      :__clockid_t => :int,
      :clockid_t => :int,
      :__cpuid_t => :ulong,
      :cpuid_t => :ulong,
      :daddr32_t => :int,
      :__dev_t => :int,
      :dev_t => :int,
      :__fixpt_t => :uint,
      :fixpt_t => :uint,
      :__gid_t => :uint,
      :gid_t => :uint,
      :__id_t => :uint,
      :id_t => :uint,
      :__in_addr_t => :uint,
      :in_addr_t => :uint,
      :__in_port_t => :ushort,
      :in_port_t => :ushort,
      :__int16_t => :short,
      :int16_t => :short,
      :__int32_t => :int,
      :int32_t => :int,
      :__int64_t => :long_long,
      :int64_t => :long_long,
      :__int8_t => :char,
      :int8_t => :char,
      :__int_fast16_t => :int,
      :__int_fast32_t => :int,
      :__int_fast64_t => :long_long,
      :__int_fast8_t => :int,
      :__int_least16_t => :short,
      :__int_least32_t => :int,
      :__int_least64_t => :long_long,
      :__int_least8_t => :char,
      :__intmax_t => :long_long,
      :__intptr_t => :long,
      :__key_t => :long,
      :key_t => :long,
      :__mode_t => :uint,
      :mode_t => :uint,
      :__nlink_t => :uint,
      :nlink_t => :uint,
      :__off_t => :long_long,
      :off_t => :long_long,
      :__paddr_t => :ulong,
      :paddr_t => :ulong,
      :__pid_t => :int,
      :pid_t => :int,
      :__psize_t => :ulong,
      :psize_t => :ulong,
      :__ptrdiff_t => :long,
      :qaddr_t => :pointer,
      :quad_t => :long_long,
      :__rlim_t => :ulong_long,
      :rlim_t => :ulong_long,
      :__rune_t => :int,
      :__sa_family_t => :uchar,
      :sa_family_t => :uchar,
      :__segsz_t => :int,
      :segsz_t => :int,
      :__size_t => :ulong,
      :size_t => :ulong,
      :__socklen_t => :uint,
      :socklen_t => :uint,
      :__ssize_t => :long,
      :ssize_t => :long,
      :__swblk_t => :int,
      :swblk_t => :int,
      :__timer_t => :int,
      :timer_t => :int,
      :u_char => :uchar,
      :__uid_t => :uint,
      :uid_t => :uint,
      :__uint16_t => :ushort,
      :u_int16_t => :ushort,
      :uint16_t => :ushort,
      :__uint32_t => :uint,
      :u_int32_t => :uint,
      :uint32_t => :uint,
      :__uint64_t => :ulong_long,
      :u_int64_t => :ulong_long,
      :uint64_t => :ulong_long,
      :__uint8_t => :uchar,
      :u_int8_t => :uchar,
      :uint8_t => :uchar,
      :__uint_fast16_t => :uint,
      :__uint_fast32_t => :uint,
      :__uint_fast64_t => :ulong_long,
      :__uint_fast8_t => :uint,
      :__uint_least16_t => :ushort,
      :__uint_least32_t => :uint,
      :__uint_least64_t => :ulong_long,
      :__uint_least8_t => :uchar,
      :__uintmax_t => :ulong_long,
      :__uintptr_t => :ulong,
      :u_int => :uint,
      :u_long => :ulong,
      :ulong => :ulong,
      :unchar => :uchar,
      :u_quad_t => :ulong_long,
      :__useconds_t => :uint,
      :useconds_t => :uint,
      :u_short => :ushort,
      :__vaddr_t => :ulong,
      :vaddr_t => :ulong,
      :__vsize_t => :ulong,
      :vsize_t => :ulong,
      :__wchar_t => :int,
      :__wctrans_t => :pointer,
      :__wctype_t => :pointer,
      :__wint_t => :int
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end
  end

  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86 }

    subject { described_class.new(types) }

    include_examples "common typedefs"

    {
      :__clock_t => :int,
      :clock_t => :int,
      :daddr64_t => :long_long,
      :daddr_t => :int,
      :__fd_mask => :int,
      :__ino_t => :uint,
      :ino_t => :uint,
      :intptr_t => :long,
      :__register_t => :int,
      :register_t => :int,
      :__suseconds_t => :int,
      :suseconds_t => :int,
      :__time_t => :int,
      :time_t => :int,
      :uintptr_t => :ulong
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end
  end

  context "when initialized with a 64bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86_64 }

    subject { described_class.new(types) }

    include_examples "common typedefs"

    {
      :__blkcnt_t => :long_long,
      :blkcnt_t => :long_long,
      :__blksize_t => :int,
      :blksize_t => :int,
      :__clock_t => :long_long,
      :clock_t => :long_long,
      :daddr_t => :long_long,
      :__fd_mask => :uint,
      :__fsblkcnt_t => :ulong_long,
      :fsblkcnt_t => :ulong_long,
      :__fsfilcnt_t => :ulong_long,
      :fsfilcnt_t => :ulong_long,
      :__ino_t => :ulong_long,
      :ino_t => :ulong_long,
      :__register_t => :long,
      :register_t => :long,
      :sigset_t => :uint,
      :__suseconds_t => :long,
      :suseconds_t => :long,
      :__time_t => :long_long,
      :time_t => :long_long
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end
  end
end
