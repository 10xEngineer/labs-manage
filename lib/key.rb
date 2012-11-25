require 'openssl'

class KeyConvertor
	attr_accessor :key

 	SSH_TYPES      = {"rsa" => "ssh-rsa", "dsa" => "ssh-dss"}
 	SSH_CONVERSION = {"rsa" => ["e", "n"], "dsa" => ["p", "q", "g", "pub_key"]}

	def initialize(public_key)
		begin
			@key = OpenSSL::PKey::RSA.new(public_key)
		rescue OpenSSL::PKey::RSAError => e
			@key = nil
		end
	end

	def is_pem_key?
		!@key.nil?
	end

	def encode_unsigned_int_32(value)
    	out = []
    	out[0] = value >> 24 & 0xff
    	out[1] = value >> 16 & 0xff
	    out[2] = value >> 8 & 0xff
    	out[3] = value & 0xff
    	return out
  	end	

    def from_byte_array(byte_array, expected_size = nil)
      num = 0
      raise "Byte array too short" if !expected_size.nil? && expected_size != byte_array.size
      byte_array.reverse.each_with_index do |item, index|
        num += item * 256**(index)
      end
      num
    end

	def ssh_public_key
    	[SSH_TYPES["rsa"], Base64.encode64(ssh_public_key_conversion).gsub("\n", ""), ""].join(" ").strip
	end

	def ssh_public_key_conversion
    	out = [0,0,0,7].pack("C*")
    	out += SSH_TYPES["rsa"]

    	SSH_CONVERSION["rsa"].each do |method|
      		byte_array = to_byte_array(@key.public_key.send(method).to_i)
      		out += encode_unsigned_int_32(byte_array.length).pack("c*")
      		out += byte_array.pack("C*")
    	end

    	return out
  	end

	def to_byte_array(num)
		result = []
	    begin
	      result << (num & 0xff)
	      num >>= 8
	    end until (num == 0 || num == -1) && (result.last[7] == num[7])
	    result.reverse
	 end  	
end