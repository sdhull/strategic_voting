class UserMailer < ApplicationMailer
  def notify_matched(user)
    @user = user
    mail(to: @user.email, from: user.match.anonymized_email, subject: "You've been matched on MakeMineCount.org!")
  end

  def forward_message(message)
    @message = message
    mail(to: message.to.email, from: message.from.anonymized_email, subject: message.subject_line)
  end
end
