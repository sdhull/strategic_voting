class Message < ApplicationRecord
  belongs_to :to, class_name: "User"
  belongs_to :from, class_name: "User"

  validates :to, presence: true
  validates :from, presence: true

  after_create :send_message

  def send_message
    UserMailer.forward_message(self)
  end
end
