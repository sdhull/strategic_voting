class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :async, :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, email_format: {message: "please enter a valid email."}
  validate :unique_email

  belongs_to :match, class_name: "User", optional: true

  def matched?
    match_id?
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
end
