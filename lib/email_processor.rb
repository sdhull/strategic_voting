class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    to = Array(@email.to).first
    uuid = to[:token].split("+").last
    to_user = User.find_by_uuid(uuid)
    from_user = User.find_by_email(@email.from[:email])

    Message.create! to: to_user, from: from_user, subject_line: @email.subject, body: @email.body
  end
end
