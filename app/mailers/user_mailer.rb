class UserMailer < ActionMailer::Base
  default from: "help@10xengineer.me"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url = "http://manage.10xlabs.net/users/#{user.activation_token}/activate"

    mail to: user.email, subject: "Labs: Sign-up confirmation"
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

  def reset_password_email(user)
    @user = user
    @url = "http://manage.10xlabs.net/password_resets/#{user.reset_password_token}/edit"

    mail to: user.email, subject: "Password reset"
  end
end
