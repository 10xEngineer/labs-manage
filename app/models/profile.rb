class Profile
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	
	field :machines, type: Integer
	field :memory, type: Integer
	field :transfer, type: Integer
end