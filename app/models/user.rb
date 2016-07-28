class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, email_format: {message: "please enter a valid email."}
  validate :unique_email

  private

  def unique_email
    if term = email.match(/.*\+/)
      term = term[0]
      if User.where("email LIKE '?%'", term).exists?
        errors.add :email, "has been taken."
      end
    end
  end
end
