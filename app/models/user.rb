class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :async, :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates :email, email_format: {message: "please enter a valid email."}
  validate :unique_email
  validates :desired_candidate, presence: true, allow_blank: false
  validate :valid_phone, if: :phone?
  after_validation :report_validation_errors_to_rollbar
  after_commit :notify_matched, if: :just_matched?, on: :update

  belongs_to :match, class_name: "User", optional: true
  belongs_to :us_state, class_name: "State", foreign_key: "state", primary_key: "short_name"
  has_many :identities, dependent: :destroy

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

  def clinton_voter?
    desired_candidate == "Hillary Clinton"
  end

  def safe_state?
    !us_state.swing?
  end

  # Internally store phone numbers as numbers
  def phone=(num)
    num.gsub!(/\D/, '')
    super(num)
  end

  def match_preference=(array)
    super(array.reject(&:blank?))
  end

  def match_with(user)
    User.transaction do
      self.update_attribute :match_id, user.id
      user.update_attribute :match_id, self.id
    end
  end

  def anonymized_email
    "#{name} <connect+#{uuid}@#{ENV['MAIL_DOMAIN']}>"
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
          state: TEMP_STATE,
          desired_candidate: TEMP_CANDIDATE
        )
        user.skip_confirmation! if email_is_verified
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def default_social_email?
    self.email && self.email.match(TEMP_EMAIL_REGEX)
  end

  def default_social_data?
    state == TEMP_STATE || state == TEMP_CANDIDATE || default_social_email?
  end

  def display_email
    email unless default_social_email?
  end

  private

  def just_matched?
    match_id? && match_id_changed?
  end

  def notify_matched
    MailerJob.perform_later "UserMailer", "notify_matched", self
  end

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
