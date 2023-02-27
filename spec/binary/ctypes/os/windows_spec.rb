require 'spec_helper'
require 'ronin/support/binary/ctypes/os/windows'
require 'ronin/support/binary/ctypes/arch/x86'
require 'ronin/support/binary/ctypes/arch/x86_64'

describe Ronin::Support::Binary::CTypes::OS::Windows do
  shared_examples_for "common typedefs" do
    {
      :_dev_t => :uint,
      :dev_t => :uint,
      :errno_t => :int,
      :_ino_t => :ushort,
      :ino_t => :ushort,
      :int16_t => :short,
      :int32_t => :int,
      :int64_t => :long_long,
      :int8_t => :char,
      :int_fast16_t => :short,
      :int_fast32_t => :int,
      :int_fast64_t => :long_long,
      :int_fast8_t => :char,
      :int_least16_t => :short,
      :int_least32_t => :int,
      :int_least64_t => :long_long,
      :int_least8_t => :char,
      :intmax_t => :long_long,
      :_mode_t => :ushort,
      :mode_t => :ushort,
      # :off32_t => :long,
      :_off64_t => :long_long,
      :off64_t => :long_long,
      # :_off_t => :long,
      :off_t => :long_long,
      # :__time32_t => :long,
      :__time64_t => :long_long,
      :uint16_t => :ushort,
      :uint64_t => :ulong_long,
      :uint8_t => :uchar,
      :uint_fast16_t => :ushort,
      :uint_fast32_t => :uint,
      :uint_fast64_t => :ulong_long,
      :uint_fast8_t => :uchar,
      :uint_least16_t => :ushort,
      :uint_least64_t => :ulong_long,
      :uint_least8_t => :uchar,
      :uintmax_t => :ulong_long,
      :useconds_t => :uint,
      :wchar_t => :ushort,
      :wctype_t => :ushort,
      :wint_t => :ushort
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end

    # :long typedefs
    [:off32_t, :_off_t, :__time32_t].each do |type|
      it "must override the #{type.inspect} type to be :int32 instead" do
        expect(subject[type]).to eq(types[:int32])
      end
    end
  end

  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::CTypes::Arch::X86 }

    subject { described_class.new(types) }

    include_examples "common typedefs"

    {
      :intptr_t => :int,
      :_pid_t => :int,
      :pid_t => :int,
      :ptrdiff_t => :int,
      :rsize_t => :uint,
      :_sigset_t => :ulong,
      :size_t => :uint,
      :ssize_t => :int,
      :time_t => :long,
      :uintptr_t => :uint
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end
  end

  context "when initialized with a 64bit Types module" do
    let(:types) { Ronin::Support::Binary::CTypes::Arch::X86_64 }

    subject { described_class.new(types) }

    include_examples "common typedefs"

    {
      :intptr_t => :long_long,
      :_pid_t => :long_long,
      :pid_t => :long_long,
      :ptrdiff_t => :long_long,
      :rsize_t => :ulong_long,
      :_sigset_t => :ulong_long,
      :size_t => :ulong_long,
      :ssize_t => :long_long,
      :time_t => :long_long,
      :uintptr_t => :ulong_long
    }.each do |typedef_name,type|
      it "must define a #{typedef_name.inspect} -> #{type.inspect} typedef" do
        expect(subject[typedef_name]).to eq(types[type])
      end
    end

    it "must override the :long type to be :int32 instead" do
      expect(subject[:long]).to eq(types::INT32)
    end

    it "must override the :ulong type to be :uint32 instead" do
      expect(subject[:ulong]).to eq(types::UINT32)
    end
  end
end
