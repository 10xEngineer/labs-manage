class Key
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String

	field :fingerprint, type: String
	field :public_key, type: String

	belongs_to :user	

	validates_presence_of :name
	validates_presence_of :public_key
end