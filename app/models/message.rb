class Message < ApplicationRecord
  belongs_to :to, class_name: "User"
  belongs_to :from, class_name: "User"

  validates :to, presence: true
  validates :from, presence: true

  after_commit :send_message, on: :create

  def send_message
    MailerJob.perform_later "UserMailer", "forward_message", self
  end
end
