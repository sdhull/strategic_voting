class MailerJob < ApplicationJob
  queue_as :default

  def perform(mailer_class, mailer_method, *args)
    ActiveRecord::Base.connection_pool.with_connection do
      mail = mailer_class.send mailer_method, *args
      mail.deliver_now
    end
  end
end
