class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    to = Array(@email.to).first
    uuid = to[:token].split("+").last
    to_user = User.find_by_uuid(uuid)
    from_email = @email.from[:email]
    from_user = User.find_by_email(from_email)
    if from_user.blank?
      address = Mail::Address.new from_email
      term = "#{address.local}+%@#{address.domain}"
      from_user = User.where("email LIKE ?", term).first
    end
    if from_user.blank? # STILL??!
      # OK let's give em the benefit of the doubt
      from_user = to_user.match
    end

    Message.create! to: to_user, from: from_user, subject_line: @email.subject, body: @email.body
  end
end
