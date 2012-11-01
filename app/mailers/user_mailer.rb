class UserMailer < ActionMailer::Base
  # TODO temporary for testing (need to setup DKIM on 10xEngineer.me)
  default from: "darkside@opsfactory.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url = "http://gattaca.laststation.net:3000/users/#{user.activation_token}/activate"

    mail to: user.email, subject: "10xEngineer Labs: Sign-up confirmation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    @url = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"

    mail to: user.email, subject: "Welcome to Labs!"
  end
end
