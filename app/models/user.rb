class User
	include Mongoid::Document
	include Mongoid::Timestamps

	include Sorcery::Model
  	include Sorcery::Model::Adapters::Mongoid

  	attr_accessor :password, :password_confirmation

  	authenticates_with_sorcery!

	field :email, type: String
	field :name, type: String
	
	field :cpwd, type: String
	field :salt, type: String

	belongs_to :account, :foreign_key => :def_account
	field :def_account, type: Moped::BSON::ObjectId

	has_many :access_tokens
	has_many :keys

	field :service, type: Boolean, default: false
	field :disabled, type: Boolean, default: false

	has_many :access_tokens, :foreign_key => :user

	validates_confirmation_of :password, :on => :create
	#validates_presence_of :password_confirmation, :if => :password_changed?
end