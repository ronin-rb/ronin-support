require 'spec_helper'
require 'ronin/support/binary/types/os/macos'
require 'ronin/support/binary/types/arch/x86'
require 'ronin/support/binary/types/arch/x86_64'

describe Ronin::Support::Binary::Types::OS::MacOS do
  shared_examples_for "common typedefs" do
    {
      :blkcnt_t => :long_long,
      :blksize_t => :int,
      :caddr_t => :string,
      :clock_t => :ulong,
      :daddr_t => :int,
      :__darwin_blkcnt_t => :long_long,
      :__darwin_blksize_t => :int,
      :__darwin_clock_t => :ulong,
      :__darwin_ct_rune_t => :int,
      :__darwin_dev_t => :int,
      :__darwin_fsblkcnt_t => :uint,
      :__darwin_fsfilcnt_t => :uint,
      :__darwin_gid_t => :uint,
      :__darwin_id_t => :uint,
      :__darwin_ino64_t => :ulong_long,
      :__darwin_ino_t => :ulong_long,
      :__darwin_intptr_t => :long,
      :__darwin_mach_port_name_t => :uint,
      :__darwin_mach_port_t => :uint,
      :__darwin_mode_t => :ushort,
      :__darwin_natural_t => :uint,
      :__darwin_off_t => :long_long,
      :__darwin_pid_t => :int,
      :__darwin_pthread_key_t => :ulong,
      :__darwin_rune_t => :int,
      :__darwin_sigset_t => :uint,
      :__darwin_size_t => :ulong,
      :__darwin_socklen_t => :uint,
      :__darwin_ssize_t => :long,
      :__darwin_suseconds_t => :int,
      :__darwin_time_t => :long,
      :__darwin_uid_t => :uint,
      :__darwin_useconds_t => :uint,
      :__darwin_wchar_t => :int,
      :__darwin_wint_t => :int,
      :dev_t => :int,
      :fd_mask => :int,
      :fixpt_t => :uint,
      :fsblkcnt_t => :uint,
      :fsfilcnt_t => :uint,
      :gid_t => :uint,
      :id_t => :uint,
      :in_addr_t => :uint,
      :ino64_t => :ulong_long,
      :ino_t => :ulong_long,
      :in_port_t => :ushort,
      :__int16_t => :short,
      :int16_t => :short,
      :__int32_t => :int,
      :int32_t => :int,
      :__int64_t => :long_long,
      :int64_t => :long_long,
      :__int8_t => :char,
      :int8_t => :char,
      :intptr_t => :long,
      :key_t => :int,
      :mode_t => :ushort,
      :nlink_t => :ushort,
      :off_t => :long_long,
      :pid_t => :int,
      :pthread_key_t => :ulong,
      :qaddr_t => :pointer,
      :quad_t => :long_long,
      :rlim_t => :ulong_long,
      :sa_family_t => :uchar,
      :segsz_t => :int,
      :size_t => :ulong,
      :socklen_t => :uint,
      :ssize_t => :long,
      :suseconds_t => :int,
      :swblk_t => :int,
      :syscall_arg_t => :ulong_long,
      :time_t => :long,
      :u_char => :uchar,
      :uid_t => :uint,
      :__uint16_t => :ushort,
      :u_int16_t => :ushort,
      :__uint32_t => :uint,
      :u_int32_t => :uint,
      :__uint64_t => :ulong_long,
      :u_int64_t => :ulong_long,
      :__uint8_t => :uchar,
      :u_int8_t => :uchar,
      :uintptr_t => :ulong,
      :u_int => :uint,
      :u_long => :ulong,
      :u_quad_t => :ulong_long,
      :useconds_t => :uint,
      :user_addr_t => :ulong_long,
      :user_long_t => :long_long,
      :user_size_t => :ulong_long,
      :user_ssize_t => :long_long,
      :user_time_t => :long_long,
      :user_ulong_t => :ulong_long,
      :u_short => :ushort
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end

    it "must define a :__darwin_uuid_t -> ArrayType.new(UCHAR,16) typedef" do
      expect(subject[:__darwin_uuid_t]).to be_kind_of(Ronin::Support::Binary::Types::ArrayType)
      expect(subject[:__darwin_uuid_t].type).to eq(types::UCHAR)
      expect(subject[:__darwin_uuid_t].length).to eq(16)
    end
  end

  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86 }

    subject { described_class.new(types) }

    include_examples "common typedefs"

    {
      :__darwin_ptrdiff_t => :int,
      :register_t => :int
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
      :__darwin_ptrdiff_t => :long,
      :errno_t => :int,
      :int_fast16_t => :short,
      :int_fast32_t => :int,
      :int_fast64_t => :long_long,
      :int_fast8_t => :char,
      :int_least16_t => :short,
      :int_least32_t => :int,
      :int_least64_t => :long_long,
      :int_least8_t => :char,
      :intmax_t => :long,
      :ptrdiff_t => :long,
      :register_t => :long_long,
      :rsize_t => :ulong,
      :sae_associd_t => :uint,
      :sae_connid_t => :uint,
      :uint16_t => :ushort,
      :uint32_t => :uint,
      :uint64_t => :ulong_long,
      :uint8_t => :uchar,
      :uint_fast16_t => :ushort,
      :uint_fast32_t => :uint,
      :uint_fast64_t => :ulong_long,
      :uint_fast8_t => :uchar,
      :uint_least16_t => :ushort,
      :uint_least32_t => :uint,
      :uint_least64_t => :ulong_long,
      :uint_least8_t => :uchar,
      :uintmax_t => :ulong,
      :user_off_t => :long_long,
      :wchar_t => :int
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end

    it "must define a :__darwin_uuid_string_t -> ArrayType.new(CHAR,37) typedef" do
      expect(subject[:__darwin_uuid_string_t]).to be_kind_of(Ronin::Support::Binary::Types::ArrayType)
      expect(subject[:__darwin_uuid_string_t].type).to eq(types::CHAR)
      expect(subject[:__darwin_uuid_string_t].length).to eq(37)
    end
  end
end
