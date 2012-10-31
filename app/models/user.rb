class User
	include Mongoid::Document
	include Mongoid::Timestamps

	include Sorcery::Model
  	include Sorcery::Model::Adapters::Mongoid

  	attr_accessor :password, :password_confirm

  	authenticates_with_sorcery!

	field :email, type: String
	field :name, type: String
	
	field :cpwd, type: String
	field :salt, type: String

	belongs_to :account, :foreign_key => :def_account

	has_many :access_tokens
	has_many :keys

	field :service, type: Boolean, default: false
	field :disabled, type: Boolean, default: false

	has_many :access_tokens, :foreign_key => :user
end