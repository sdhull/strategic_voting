class UserMailerPreview < ActionMailer::Preview
  def notify_matched
    UserMailer.notify_matched(User.first)
  end

  def forward_message
  end

  def match_preference
    UserMailer.match_preference(User.first)
  end
end
