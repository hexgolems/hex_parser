require "hex_parser/version"

module Hex
  class IntSpec
    attr_accessor :size #1,2,4,8 (bytes)
    attr_accessor :endianes #(:little or :big)
    attr_accessor :signed #(true or false)

    def initialize(size, signed = :signed,  endianess = :little)
      @size,@endianess,@signed= size,endianess, signed
    end

    # @size = 1,2,4,8 in bytes
    # @signed = :singed, :unsigned
    def get_unpack()
      pack_str = { 1 => 'C', 2 => 'S<', 4 => 'L<', 8 => 'Q<' }[size]
      pack_str.downcase! if signed == :signed
      pack_str
    end

    # bitsize = 8,16,32,64
    # signed = :singed, :unsigned
    def read(mem,address)
      content = mem.read(address, @size)
      content.reverse! if @endianess == :big
      return content.unpack(get_unpack)[0]
    end
  end

  class StructSpec
    attr_accessor :members
    def read(mem,address)
      addr = address
      return @members.map do |m|
        m.read(mem,addr)
        addr += m.size
      end
    end

    def size
      @members.inject(0){|s,e| s+s.size}
    end
  end

  Int8 = IntSpec.new(1)
  Uint8 = IntSpec.new(1,:unsigned)
  Uint8B = IntSpec.new(1,:unsigned, :big)

  Int16 = IntSpec.new(2)
  Uint16 = IntSpec.new(2,:unsigned)
  Uint16B = IntSpec.new(2,:unsigned, :big)

  Int32 = IntSpec.new(4)
  Uint32 = IntSpec.new(4,:unsigned)
  Uint32B = IntSpec.new(4,:unsigned, :big)

  Int64 = IntSpec.new(8)
  Uint64 = IntSpec.new(8,:unsigned)
  Uint64B = IntSpec.new(8,:unsigned, :big)
end
