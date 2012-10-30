class Key
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String

	field :fingerprint, type: String
	field :public_key, type: String

	belongs_to :user	
end