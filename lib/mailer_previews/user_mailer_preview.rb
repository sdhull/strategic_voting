class UserMailerPreview < ActionMailer::Preview
  def notify_matched
    UserMailer.notify_matched(User.first)
  end

  def forward_message
    UserMailer
  end
end
