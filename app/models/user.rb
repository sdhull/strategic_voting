class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :async, :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, email_format: {message: "please enter a valid email."}
  validate :unique_email
  validates :desired_candidate, presence: true, allow_blank: false
  validate :valid_phone, if: :phone?
  after_validation :report_validation_errors_to_rollbar

  belongs_to :match, class_name: "User", optional: true

  def matched?
    match_id?
  end

  # Internally store phone numbers as numbers
  def phone=(num)
    num.gsub!(/\D/, '')
    super(num)
  end

  private

  def unique_email
    if term = email.match(/.*\+/)
      term = "#{term[0]}%"
      if user = User.where("email LIKE ?", term).last
        if user != self
          errors.add :email, "has been taken."
        end
      end
    end
  end

  def valid_phone
    if phone.length == 10 || (phone.length == 11 && phone[0] == '1')
      # phone is valid
    else
      errors.add :phone, "is invalid."
    end
  end
end
