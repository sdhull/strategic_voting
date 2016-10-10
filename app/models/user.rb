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
  belongs_to :us_state, class_name: "State", foreign_key: "state", primary_key: "short_name"

  def self.in_swing_state
    joins(:us_state).merge(State.swing)
  end

  def self.in_uncontested_state
    joins(:us_state).merge(State.uncontested)
  end

  def self.clinton
    where(desired_candidate: "Hillary Clinton")
  end

  def self.third_party
    where(desired_candidate: ["Jill Stein", "Gary Johnson"])
  end

  def self.unmatched
    where(match_id: nil)
  end

  def self.matched
    where("match_id IS NOT NULL")
  end

  def matched?
    match_id?
  end

  # Internally store phone numbers as numbers
  def phone=(num)
    num.gsub!(/\D/, '')
    super(num)
  end

  def match_with(user)
    User.transaction do
      self.update_attribute :match_id, user.id
      user.update_attribute :match_id, self.id
    end
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
