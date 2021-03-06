class User
	include Mongoid::Document
	include Mongoid::Timestamps

	include Sorcery::Model
  	include Sorcery::Model::Adapters::Mongoid

  	attr_accessor :password, :password_confirmation

  	authenticates_with_sorcery!

	field :email, type: String
	field :name, type: String

	field :role, type:String, default: nil
	
	field :cpwd, type: String
	field :salt, type: String

	belongs_to :account, :foreign_key => :def_account
	field :def_account, type: Moped::BSON::ObjectId

	has_many :access_tokens
	has_many :keys

	field :limits, type: Hash

	field :service, type: Boolean, default: false
	field :disabled, type: Boolean, default: false
	field :tc_agreed, type: Boolean, default: false

	has_many :access_tokens, :foreign_key => :user

	# user activation
	field :activation_state, type: String, default: nil
	field :activation_token, type: String, default: nil
	field :activation_token_expires_at, type: DateTime, default: nil

	field :reset_password_token, type: String, default: nil
	field :reset_password_token_expires_at, type: DateTime, default: nil
	field :reset_password_email_sent_at, type: DateTime, default: nil

	field :customer_io, type: Boolean, default: false

	#validates :tc_agreed, :acceptance => {:accept => true}
	validates_uniqueness_of :email
	validates_presence_of :email
	validates_presence_of :password, :on => :create
	validates_confirmation_of :password, :on => :create

	validates :email, :email_format => {:message => 'is not valid email address'}

	def is_admin?
		self.role == "admin"
	end
end