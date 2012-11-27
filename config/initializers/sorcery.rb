# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features (password encryption, login/logout).
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external
Rails.application.config.sorcery.submodules = [:remember_me, :user_activation, :reset_password]

#:reset_password

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  # -- core --
  # What controller action to call for non-authenticated users. You can also
  # override the 'not_authenticated' method of course.
  # Default: `:not_authenticated`
  #
  # config.not_authenticated_action =


  # When a non logged in user tries to enter a page that requires login, save
  # the URL he wanted to reach, and send him there after login, using 'redirect_back_or_to'.
  # Default: `true`
  #
  # config.save_return_to_url =


  # Set domain option for cookies; Useful for remember_me submodule.
  # Default: `nil`
  #
  # config.cookie_domain =


  # -- session timeout --
  # How long in seconds to keep the session alive.
  # Default: `3600`
  #
  # config.session_timeout =


  # Use the last action as the beginning of session timeout.
  # Default: `false`
  #
  # config.session_timeout_from_last_action =


  # -- http_basic_auth --
  # What realm to display for which controller name. For example {"My App" => "Application"}
  # Default: `{"application" => "Application"}`
  #
  # config.controller_to_realm_map =


  # -- activity logging --
  # will register the time of last user login, every login.
  # Default: `true`
  #
  # config.register_login_time =


  # will register the time of last user logout, every logout.
  # Default: `true`
  #
  # config.register_logout_time =


  # will register the time of last user action, every action.
  # Default: `true`
  #
  # config.register_last_activity_time =


  # -- external --
  # What providers are supported by this app, i.e. [:twitter, :facebook, :github, :google, :liveid] .
  # Default: `[]`
  #
  # config.external_providers =


  # You can change it by your local ca_file. i.e. '/etc/pki/tls/certs/ca-bundle.crt'
  # Path to ca_file. By default use a internal ca-bundle.crt.
  # Default: `'path/to/ca_file'`
  #
  # config.ca_file =


  # Twitter wil not accept any requests nor redirect uri containing localhost,
  # make sure you use 0.0.0.0:3000 to access your app in development
  #
  # config.twitter.key = ""
  # config.twitter.secret = ""
  # config.twitter.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=twitter"
  # config.twitter.user_info_mapping = {:email => "screen_name"}
  #
  # config.facebook.key = ""
  # config.facebook.secret = ""
  # config.facebook.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=facebook"
  # config.facebook.user_info_mapping = {:email => "name"}
  #
  # config.github.key = ""
  # config.github.secret = ""
  # config.github.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=github"
  # config.github.user_info_mapping = {:email => "name"}
  #
  # config.google.key = ""
  # config.google.secret = ""
  # config.google.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=google"
  # config.google.user_info_mapping = {:email => "email", :username => "name"}
  #
  # To use liveid in development mode you have to replace mydomain.com with
  # a valid domain even in development. To use a valid domain in development
  # simply add your domain in your /etc/hosts file in front of 127.0.0.1
  #
  # config.liveid.key = ""
  # config.liveid.secret = ""
  # config.liveid.callback_url = "http://mydomain.com:3000/oauth/callback?provider=liveid"
  # config.liveid.user_info_mapping = {:username => "name"}


  # --- user config ---
  config.user_config do |user|
    user.username_attribute_names = [:email]
    user.password_attribute_name = :password
    user.downcase_username_before_authenticating = true
    user.email_attribute_name = :email
    user.crypted_password_attribute_name = :cpwd
    # user.salt_join_token =
    # user.salt_attribute_name =
    # user.stretches =
    # user.encryption_key =
    # user.custom_encryption_provider =
    # user.encryption_algorithm =
    # user.subclasses_inherit_config =
    # user.activation_state_attribute_name =
    # user.activation_token_attribute_name =
    # user.activation_token_expires_at_attribute_name =
    user.activation_token_expiration_period = 2.days
    user.user_activation_mailer = UserMailer
    # user.activation_mailer_disabled =
    # user.activation_needed_email_method_name =
    user.activation_success_email_method_name = nil
    # user.prevent_non_active_users_to_login =
    # user.reset_password_token_attribute_name =
    # user.reset_password_token_expires_at_attribute_name =
    # user.reset_password_email_sent_at_attribute_name =
    user.reset_password_mailer = UserMailer
    # user.reset_password_email_method_name =
    # user.reset_password_mailer_disabled =
    # user.reset_password_expiration_period =
    # user.reset_password_time_between_emails =
    # user.failed_logins_count_attribute_name =
    # user.lock_expires_at_attribute_name =
    # user.consecutive_login_retries_amount_limit =
    # user.login_lock_time_period =
    # user.unlock_token_attribute_name =
    # user.unlock_token_email_method_name =
    # user.unlock_token_mailer_disabled = true
    # user.unlock_token_mailer = UserMailer

    # -- activity logging --
    # Last login attribute name.
    # Default: `:last_login_at`
    #
    # user.last_login_at_attribute_name =


    # Last logout attribute name.
    # Default: `:last_logout_at`
    #
    # user.last_logout_at_attribute_name =


    # Last activity attribute name.
    # Default: `:last_activity_at`
    #
    # user.last_activity_at_attribute_name =


    # How long since last activity is he user defined logged out?
    # Default: `10 * 60`
    #
    # user.activity_timeout =


    # -- external --
    # Class which holds the various external provider data for this user.
    # Default: `nil`
    #
    # user.authentications_class =


    # User's identifier in authentications class.
    # Default: `:user_id`
    #
    # user.authentications_user_id_attribute_name =


    # Provider's identifier in authentications class.
    # Default: `:provider`
    #
    # user.provider_attribute_name =


    # User's external unique identifier in authentications class.
    # Default: `:uid`
    #
    # user.provider_uid_attribute_name =
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = "User"
end
