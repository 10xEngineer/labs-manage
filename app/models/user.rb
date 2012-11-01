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
	field :tc_agreed, type: Boolean, default: false

	has_many :access_tokens, :foreign_key => :user

	# user activation
	field :activation_state, type: String, default: nil
	field :activation_token, type: String, default: nil
	field :activation_token_expires_at, type: DateTime, default: nil

	#validates :tc_agreed, :acceptance => {:accept => true}
	validates_uniqueness_of :email
	validates_presence_of :email
	validates_presence_of :password, :on => :create
	validates_confirmation_of :password, :on => :create
end