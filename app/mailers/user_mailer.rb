class UserMailer < ApplicationMailer
  def notify_matched(user)
    @user = user
    user.match(true) # force the match to be reloaded
    mail(to: @user.email, from: user.match.anonymized_email, subject: "You've been matched on MakeMineCount.org!")
  end

  def forward_message(message)
    @message = message
    mail(to: message.to.email, from: message.from.anonymized_email, subject: message.subject_line)
  end

  def match_preference(user)
    @user = user
    mail(to: user.email, subject: "Who do you want to swap your vote for? [makeminecount.org]")
  end

  def trump_trader(user)
    @user = user
    mail(to: user.email, subject: "Get matched with a third party voter! [makeminecount.org]")
  end
end
