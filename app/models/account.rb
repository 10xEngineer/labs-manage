require 'rufus/mnemo'

class Account
	include Mongoid::Document
	include Mongoid::Timestamps

	field :handle, type: String
	field :account_ref, type: String

	field :owners, type: Array

	# TODO organization detail

	field :disabled, type: Boolean, default: false
	field :organization, type: Boolean, default: false

	def self.gen_reference(length = 8)
		reference = []

		reference << ("ac" << Rufus::Mnemo.from_integer(rand(68) + 1))
		reference << ((0..length).map{rand(256).chr}*"").unpack("H*")[0][0,length]

		reference.join('-')
	end
end