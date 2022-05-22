require 'spec_helper'
require 'ronin/support/binary/hexdump/parser'

describe Binary::Hexdump::Parser do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  def read_binary_file(name)
    File.binread(File.join(fixtures_dir,"#{name}"))
  end

  def read_file(name)
    File.read(File.join(fixtures_dir,"#{name}"))
  end

  describe "#initialize" do
    it "must default #format to :hexdump" do
      expect(subject.format).to eq(:hexdump)
    end

    it "must default #type to the :byte type" do
      expect(subject.type).to be(described_class::TYPES[:byte])
    end

    context "when the type: keyword argument is given" do
      let(:type) { :uint32 }

      subject { described_class.new(type: type) }

      it "must set #type by looking up the type: keyword value in TYPES" do
        expect(subject.type).to be(described_class::TYPES[type])
      end

      context "but the type is not a scalar type" do
        let(:type) { :string }

        it do
          expect {
            described_class.new(type: type)
          }.to raise_error(ArgumentError,"only scalar types are support: #{type.inspect}")
        end
      end
    end

    context "when the given format: is :hexdump" do
      subject { described_class.new(format: :hexdump) }

      it "must set #address_base to 16" do
        expect(subject.address_base).to eq(16)
      end

      it "must set #base to 16" do
        expect(subject.base).to eq(16)
      end
    end

    context "when the given format: is :od" do
      subject { described_class.new(format: :od) }

      it "must default #address_base to 8" do
        expect(subject.address_base).to eq(8)
      end

      it "must default #base to 8" do
        expect(subject.base).to eq(8)
      end
    end

    context "when the given format: is neither :hexdump nor :od" do
      let(:format) { :foo }

      it do
        expect {
          described_class.new(format: format)
        }.to raise_error(ArgumentError,"format: must be either :hexdump or :od, was #{format.inspect}")
      end
    end
  end

  describe "#parse_address" do
    let(:address) { 0xffffffff }

    subject { described_class.new(address_base: address_base) }

    context "when #address_base is 2" do
      let(:address_base)   { 2 }
      let(:address_string) { "%.32b" % address }

      it "must parse the address as binary" do
        expect(subject.parse_address(address_string)).to eq(address)
      end
    end

    context "when #address_base is 8" do
      let(:address_base)   { 8 }
      let(:address_string) { "%.11o" % address }

      it "must parse the address as octal" do
        expect(subject.parse_address(address_string)).to eq(address)
      end
    end

    context "when #address_base is 10" do
      let(:address_base)   { 10 }
      let(:address_string) { "%.10d" % address }

      it "must parse the address as decimal" do
        expect(subject.parse_address(address_string)).to eq(address)
      end
    end

    context "when #address_base is 16" do
      let(:address_base)   { 16 }
      let(:address_string) { "%.8x" % address }

      it "must parse the address as hexadecimal" do
        expect(subject.parse_address(address_string)).to eq(address)
      end
    end
  end

  describe "#parse_int" do
    let(:int) { 0xffffffff }
    let(:int_string) { int.to_s(subject.base) }

    context "when #base is 2" do
      let(:base) { 2 }

      subject { described_class.new(base: base) }

      it "must parse the integer" do
        expect(subject.parse_int(int_string)).to eq(int)
      end
    end

    context "when #base is 8" do
      let(:base) { 8 }

      subject { described_class.new(base: base) }

      it "must parse the integer" do
        expect(subject.parse_int(int_string)).to eq(int)
      end
    end

    context "when #base is 10" do
      let(:base) { 10 }

      subject { described_class.new(base: base) }

      it "must parse the integer" do
        expect(subject.parse_int(int_string)).to eq(int)
      end
    end

    context "when #base is 16" do
      let(:base) { 16 }

      subject { described_class.new(base: base) }

      it "must parse the integer" do
        expect(subject.parse_int(int_string)).to eq(int)
      end
    end
  end

  describe "#parse_char_or_int" do
    context "and when initialized with `type: char`" do
      subject { described_class.new(type: :char) }

      context "and the given string is a character" do
        it "must return the byte value of the character" do
          expect(subject.parse_char_or_int('A')).to eq(0x41)
        end
      end

      context "and the given string is an escaped character" do
        it "must return the byte value of the escaped character" do
          expect(subject.parse_char_or_int('\\n')).to eq(0x0a)
        end
      end

      context "but the given string is an integer" do
        let(:int) { 0xffffffff }
        let(:int_string) { int.to_s(subject.base) }

        it "must parse the integer" do
          expect(subject.parse_char_or_int(int_string)).to eq(int)
        end
      end

      context "and when initialized with `format: :od, named_chars: true`" do
        subject do
          described_class.new(
            format: :od,
            type:   :char,
            named_chars: true
          )
        end

        context "and the given string is a named character" do
          it "must return the byte value of the named character" do
            expect(subject.parse_char_or_int('nul')).to eq(0x00)
          end
        end

        context "and the given string is a character" do
          it "must return the byte value of the character" do
            expect(subject.parse_char_or_int('A')).to eq(0x41)
          end
        end

        context "but the given string is an integer" do
          let(:int) { 0xffffffff }
          let(:int_string) { int.to_s(subject.base) }

          it "must parse the integer" do
            expect(subject.parse_char_or_int(int_string)).to eq(int)
          end
        end
      end
    end
  end

  describe "#parse_float" do
    let(:float)        { 0.5        }
    let(:float_string) { float.to_s }

    it "must parse the string as a floating-point number" do
      expect(subject.parse_float(float_string)).to eq(float)
    end
  end

  describe "#parse_line" do
    let(:number_formats) do
      {
        2  => "%.8b",
        8  => "%.3o",
        10 => "%3d",
        16 => "%.2x"
      }
    end

    let(:address)        { 0xffffffff }
    let(:address_base)   { 16 }
    let(:address_format) { "%.8x" }
    let(:address_string) { address_format % address }

    let(:numbers) { [*0xf0..0xff]  }
    let(:number_format) { number_formats.fetch(subject.base) }
    let(:numbers_string) do
      numbers.map { |v| number_format % v }.join(' ')
    end

    let(:parsed_line) { [address, numbers] }
    let(:line_string) { "#{address_string}  #{numbers_string}" }

    shared_examples "#parse_line with base examples" do |base: |
      context "when #base is #{base}" do
        let(:base) { base }

        subject do
          described_class.new(base: base, address_base: address_base)
        end

        it "must parse the line" do
          expect(subject.parse_line(line_string)).to eq(parsed_line)
        end

        context "and when initialized with `address_base: 2`" do
          let(:address_base)   { 2 }
          let(:address_string) { "%.32b" % address }

          it "must parse binary addresses" do
            expect(subject.parse_line(line_string).first).to eq(address)
          end
        end

        context "and when initialized with `address_base: 8`" do
          let(:address_base)   { 8 }
          let(:address_string) { "%.11o" % address }

          it "must parse octal addresses" do
            expect(subject.parse_line(line_string).first).to eq(address)
          end
        end

        context "and when initialized with `address_base: 10`" do
          let(:address_base)   { 10 }
          let(:address_string) { "%.10d" % address }

          it "must parse decimal addresses" do
            expect(subject.parse_line(line_string).first).to eq(address)
          end
        end

        context "and when initialized with `address_base: 16`" do
          let(:address_base)   { 16 }
          let(:address_string) { "%.8x" % address }

          it "must parse hexadecimal addresses" do
            expect(subject.parse_line(line_string).first).to eq(address)
          end
        end
      end
    end

    include_context "#parse_line with base examples", base: 2
    include_context "#parse_line with base examples", base: 8
    include_context "#parse_line with base examples", base: 10
    include_context "#parse_line with base examples", base: 16

    context "when initialized with `type: :char`" do
      subject { described_class.new(type: :char) }

      context "and the given string contains escaped characters" do
        let(:numbers) { [*0x00..0x0f] }
        let(:numbers_string) do
          [
            "\\0",
            number_format % 0x01,
            number_format % 0x02,
            number_format % 0x03,
            number_format % 0x04,
            number_format % 0x05,
            number_format % 0x06,
            "\\a",
            "\\b",
            "\\t",
            "\\n",
            "\\v",
            "\\f",
            "\\r",
            number_format % 0x0e,
            number_format % 0x0f
          ]
        end
      end

      context "and the given string contains characters" do
        let(:numbers) { [*0x30..0x3f] }
        let(:numbers_string) do
          "0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?"
        end

        it "must return the byte values of the characters" do
          expect(subject.parse_line(line_string)).to eq(parsed_line)
        end
      end

      context "but the given string contains integers" do
        it "must parse the integer as binary" do
          expect(subject.parse_line(line_string)).to eq(parsed_line)
        end
      end
    end

    context "when initialized with `format: :od, type: :char, named_char: true`" do
      subject do
        described_class.new(
          format:      :od,
          type:        :char,
          named_chars: true
        )
      end

      let(:address_base)   { 8 }
      let(:address_string) { "%.11o" % address }

      context "and the given string is a named character" do
        let(:numbers) { [*0x00..0x0f] }
        let(:numbers_string) do
          "nul soh stx etx eot enq ack bel  bs  ht  nl  vt  ff  cr  so  si"
        end

        it "must return the byte value of the character" do
          expect(subject.parse_line(line_string)).to eq(parsed_line)
        end
      end

      context "and the given string contains characters" do
        let(:numbers) { [*0x30..0x3f] }
        let(:numbers_string) do
          "0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?"
        end

        it "must return the byte values of the characters" do
          expect(subject.parse_line(line_string)).to eq(parsed_line)
        end
      end
    end
  end

  describe "#parse" do
    let(:ascii)    { read_binary_file('ascii.bin')  }
    let(:raw_data) { ascii }

    let(:pack_strings) do
      subject.type.pack_string * (raw_data.bytesize / subject.type.size)
    end

    let(:parsed_numbers) { raw_data.unpack(pack_strings) }

    let(:parsed_rows) do
      parsed_numbers.each_slice(16 / subject.type.size)
    end

    let(:parsed_data) do
      parsed_rows.each_with_index.map do |numbers,index|
        [index * 16, numbers]
      end
    end

    shared_examples "#parse examples" do |**kwargs|
      inspected_kwargs = kwargs.map { |name,value|
        "#{name}: #{value.inspect}"
      }.join(', ')

      context "and `#{inspected_kwargs}`" do
        let(:format) { kwargs[:format] }
        let(:base)   { kwargs[:base]   }
        let(:type)   { kwargs[:type]   }

        let(:base_names) do
          {
            2  => 'binary',
            8  => 'octal',
            10 => 'decimal',
            16 => 'hex'
          }
        end

        subject { described_class.new(**kwargs) }

        let(:hexdump_file) do
          if base
            "#{format}_#{base_names.fetch(base)}_#{type}.txt"
          else
            "#{format}_#{type}.txt"
          end
        end

        let(:hexdump)  { read_file(hexdump_file) }

        context "when a block is given" do
          it "must yield the parsed hexdump addresses and numbers" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end
    end

    context "when initialized with `format: :hexdump`" do
      include_context "#parse examples", format: :hexdump,
                                         base:   8,
                                         type:   :byte
      include_context "#parse examples", format: :hexdump,
                                         base:   8,
                                         type:   :uint16
      include_context "#parse examples", format: :hexdump,
                                         base:   10,
                                         type:   :uint16
      include_context "#parse examples", format: :hexdump,
                                         base:   16,
                                         type:   :byte
      include_context "#parse examples", format: :hexdump,
                                         base:   16,
                                         type:   :uint16

      include_context "#parse examples", format: :hexdump,
                                         type:   :char

      context "and when the hexdump contains omitted repeated lines" do
        subject { described_class.new(format: :hexdump) }

        let(:hexdump)  { read_file('hexdump_repeated.txt') }
        let(:raw_data) { read_binary_file('repeated.bin')  }

        context "when a block is given" do
          it "must yield the repeated hexdump rows" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end
    end

    context "when initialized with `format: :od`" do
      include_context "#parse examples", format: :od,
                                         base:   8,
                                         type:   :byte
      include_context "#parse examples", format: :od,
                                         base:   8,
                                         type:   :uint16
      include_context "#parse examples", format: :od,
                                         base:   8,
                                         type:   :uint32
      include_context "#parse examples", format: :od,
                                         base:   8,
                                         type:   :uint64
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :byte
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :uint16
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :uint32
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :uint64
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :int8
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :int16
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :int32
      include_context "#parse examples", format: :od,
                                         base:   10,
                                         type:   :int64
      include_context "#parse examples", format: :od,
                                         base:   16,
                                         type:   :byte
      include_context "#parse examples", format: :od,
                                         base:   16,
                                         type:   :uint16
      include_context "#parse examples", format: :od,
                                         base:   16,
                                         type:   :uint32
      include_context "#parse examples", format: :od,
                                         base:   16,
                                         type:   :uint64

      context "and with `type: :char`" do
        subject do
          described_class.new(format: :od, type: :char)
        end

        let(:hexdump) { read_file('od_octal_char.txt') }

        context "when a block is given" do
          it "must yield the parsed the named chars" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end

      context "and with `type: :char, named_chars: true`" do
        subject do
          described_class.new(format: :od, type: :char, named_chars: true)
        end

        let(:mask)     { ~(1 << 7) }
        let(:raw_data) { ascii.bytes.map { |b| (b & mask).chr }.join }
        let(:hexdump)  { read_file('od_named_char.txt') }

        context "when a block is given" do
          it "must yield the parsed the named chars" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end

      context "and with `type: :float`" do
        subject do
          described_class.new(format: :od, type: :float)
        end

        let(:hexdump) { read_file('od_float.txt') }

        let(:parsed_numbers) do
          [
             3.8204714e-37,  1.0082514e-34,   2.6584628e-32,  7.003653e-30,
             1.8436203e-27,  4.849422e-25,    1.274669e-22,   3.348188e-20,
             8.789052e-18,   2.3057262e-15,   6.045325e-13,   1.5841256e-10,
             4.148859e-08,   1.0860433e-05,   0.0028415453,   0.74312186,
             194.25488,      50757.266,       13257032,       3.4611722e+09,
             9.033073e+11,   2.3566197e+14,   6.145978e+16,   1.6023064e+19,
             4.1759808e+21,  1.0880146e+24,   2.833864e+26,   7.3789715e+28,
             1.9208323e+31,  4.9987784e+33,   1.3005379e+36,  3.3827546e+38,
            -7.670445e-37,  -2.0240553e-34,  -5.33626e-32,   -1.4056803e-29,
            -3.6999117e-27, -9.731282e-25,   -2.557642e-22,  -6.7176346e-20,
            -1.7632526e-17, -4.6253843e-15,  -1.2126316e-12, -3.1773817e-10,
            -8.321092e-08,  -2.1780703e-05,  -0.005698409,   -1.4901652,
            -389.51367,     -101771.53,      -26579856,      -6.939187e+09,
            -1.8109264e+12, -4.7242775e+14,  -1.2320213e+17, -3.2118467e+19,
            -8.3704803e+21, -2.18077e+24,    -5.6798647e+26, -1.4789012e+29,
            -3.8496183e+31, -1.00179184e+34, -2.6062884e+36,  0.0
          ]
        end

        context "when a block is given" do
          it "must yield the parsed float values" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end

      context "and with `type: :double`" do
        subject do
          described_class.new(format: :od, type: :double)
        end

        let(:hexdump) { read_file('od_double.txt') }

        let(:parsed_numbers) do
          [
             7.949928895127363e-275,   3.6919162048650923e-236,
             1.846323925681849e-197,   8.567745616612358e-159,
             4.287943403239047e-120,   1.9882885252746607e-81,
             9.958334378896745e-43,    0.00046141357891195693,
             2.3127085096212408e+35,   1.0707780659396515e+74,
             5.37095661886286e+112,    2.4848873176582267e+151,
             1.2473230926066734e+190,  5.766497103752564e+228,
             2.8966956840444004e+267,  1.3381833135892986e+306,
            -2.081576000531694e-272,  -9.609176777827115e-234,
            -4.834030884500847e-195,  -2.2299033716331566e-156,
            -1.1225952939479768e-117, -5.1746869438707237e-79,
            -2.606955873096698e-40,   -0.12008266051518646,
            -6.0539778500895675e+37,  -2.786600511251514e+76,
            -1.405868428700574e+115,  -6.466470811086963e+153,
            -3.264714813035785e+192,  -1.5005764835379223e+231,
            -7.581280411902108e+269,   0.0
          ]
        end

        context "when a block is given" do
          it "must yield the parsed double values" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end

      context "and when the hexdump contains omitted repeating lines" do
        subject do
          described_class.new(format: :od, type: :uint16)
        end

        let(:hexdump)  { read_file('od_repeated.txt')  }
        let(:raw_data) { read_binary_file('repeated.bin') }

        let(:raw_data) do
          data = read_binary_file('repeated.bin')
          data += "\0"
          data
        end

        context "when a block is given" do
          it "must yield the repeated hexdump rows" do
            expect { |b|
              subject.parse(hexdump,&b)
            }.to yield_successive_args(*parsed_data)
          end
        end

        context "when no block is given" do
          it "must return an Enumerator object" do
            expect(subject.parse(hexdump).to_a).to eq(parsed_data)
          end
        end
      end
    end
  end

  describe "#pack" do
    let(:values)      { [*0x00..0x0f] }
    let(:type_name)   { :uint32     }
    let(:type)        { Ronin::Support::Binary::CTypes[type_name] }

    subject { described_class.new(type: type_name) }

    let(:packed_data) { values.pack(type.pack_string * values.length) }

    it "must pack the values using the type's #pack_string" do
      expect(subject.pack(values)).to eq(packed_data)
    end
  end

  describe "#unpack" do
    let(:ascii)   { read_binary_file('ascii.bin')  }
    let(:hexdump) { read_file("od_hex_#{type_name}.txt") }

    let(:type_name) { :uint32     }
    let(:type)      { Ronin::Support::Binary::CTypes[type_name] }
    let(:count)     { ascii.size / type.size }
    let(:values)    { ascii.unpack(type.pack_string * count) }

    subject { described_class.new(type: type_name) }

    it "must return the unpack values from the parsed hexdumped data" do
      expect(subject.unpack(hexdump)).to eq(values)
    end
  end

  describe "#unhexdump" do
    let(:ascii)    { read_binary_file('ascii.bin')  }
    let(:raw_data) { ascii }

    shared_examples "#unhexdump examples" do |**kwargs|
      inspected_kwargs = kwargs.map { |name,value|
        "#{name}: #{value.inspect}"
      }.join(', ')

      context "and `#{inspected_kwargs}`" do
        let(:format) { kwargs[:format] }
        let(:base)   { kwargs[:base]   }
        let(:type)   { kwargs[:type]   }

        let(:base_names) do
          {
            2  => 'binary',
            8  => 'octal',
            10 => 'decimal',
            16 => 'hex'
          }
        end

        subject { described_class.new(**kwargs) }

        let(:hexdump_file) do
          if base
            "#{format}_#{base_names.fetch(base)}_#{type}.txt"
          else
            "#{format}_#{type}.txt"
          end
        end

        let(:hexdump) { read_file(hexdump_file) }

        it "must unhexdump the hexdump output" do
          expect(subject.unhexdump(hexdump)).to eq(ascii)
        end
      end
    end

    context "when initialized with `format: :hexdump`" do
      include_context "#unhexdump examples", format: :hexdump,
                                             base:   8,
                                             type:   :byte
      include_context "#unhexdump examples", format: :hexdump,
                                             base:   8,
                                             type:   :uint16
      include_context "#unhexdump examples", format: :hexdump,
                                             base:   10,
                                             type:   :uint16
      include_context "#unhexdump examples", format: :hexdump,
                                             base:   16,
                                             type:   :byte
      include_context "#unhexdump examples", format: :hexdump,
                                             base:   16,
                                             type:   :uint16

      include_context "#unhexdump examples", format: :hexdump,
                                             type:   :char

      context "and when the hexdump contains omitted repeated lines" do
        subject do
          described_class.new(format: :hexdump)
        end

        let(:hexdump)  { read_file('hexdump_repeated.txt') }
        let(:raw_data) { read_binary_file('repeated.bin')     }

        it "must unhexdump repeated hexdump output" do
          expect(subject.unhexdump(hexdump)).to eq(raw_data)
        end
      end
    end

    context "when initialized with `format: :od`" do
      include_context "#unhexdump examples", format: :od,
                                             base:   8,
                                             type:   :byte
      include_context "#unhexdump examples", format: :od,
                                             base:   8,
                                             type:   :uint16
      include_context "#unhexdump examples", format: :od,
                                             base:   8,
                                             type:   :uint32
      include_context "#unhexdump examples", format: :od,
                                             base:   8,
                                             type:   :uint64
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :byte
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :uint16
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :uint32
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :uint64
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :int8
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :int16
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :int32
      include_context "#unhexdump examples", format: :od,
                                             base:   10,
                                             type:   :int64
      include_context "#unhexdump examples", format: :od,
                                             base:   16,
                                             type:   :byte
      include_context "#unhexdump examples", format: :od,
                                             base:   16,
                                             type:   :uint16
      include_context "#unhexdump examples", format: :od,
                                             base:   16,
                                             type:   :uint32
      include_context "#unhexdump examples", format: :od,
                                             base:   16,
                                             type:   :uint64

      context "and with `type: :char`" do
        subject do
          described_class.new(format: :od, type: :char)
        end

        let(:hexdump) { read_file('od_octal_char.txt') }

        it "must unhexdump the named chars" do
          expect(subject.unhexdump(hexdump)).to eq(raw_data)
        end
      end

      context "and with `type: :char, named_chars: true`" do
        subject do
          described_class.new(format: :od, type: :char, named_chars: true)
        end

        let(:mask)     { ~(1 << 7) }
        let(:raw_data) { ascii.bytes.map { |b| (b & mask).chr }.join }
        let(:hexdump)  { read_file('od_named_char.txt') }

        it "must unhexdump the named chars" do
          expect(subject.unhexdump(hexdump)).to eq(raw_data)
        end
      end

      context "and with `type: :float`" do
        subject do
          described_class.new(format: :od, type: :float)
        end

        let(:raw_data) do
          data = ascii.dup
          # HACK: "\xfc\xfd\xfe\xff" converts to -nan which vonerts to 0.0
          data[-4..-1] = ("\0" * 4)
          data
        end

        let(:hexdump) { read_file('od_float.txt') }

        it "must unhexdump floats" do
          expect(subject.unhexdump(hexdump)).to eq(raw_data)
        end
      end

      context "and with `type: :double`" do
        subject do
          described_class.new(format: :od, type: :double)
        end

        let(:raw_data) do
          data = ascii.dup
          # HACK: "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff" converts to -nan which
          # vonerts to 0.0
          data[-8..-1] = ("\0" * 8)
          data
        end

        let(:hexdump) { read_file('od_double.txt') }

        it "must unhexdump doubles" do
          expect(subject.unhexdump(hexdump)).to eq(raw_data)
        end
      end

      context "and when the hexdump contains omitted repeating lines" do
        subject do
          described_class.new(format: :od, type: :uint16)
        end

        let(:hexdump)  { read_file('od_repeated.txt')     }
        let(:raw_data) { read_binary_file('repeated.bin') }

        it "must unhexdump repeated hexdump output" do
          expect(subject.unhexdump(hexdump)).to eq(raw_data)
        end
      end
    end
  end
end
