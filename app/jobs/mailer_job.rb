class MailerJob < ApplicationJob
  queue_as :default

  def perform(class_name, mailer_method, *args)
    ActiveRecord::Base.connection_pool.with_connection do
      mailer_class = class_name.constantize
      mail = mailer_class.send mailer_method, *args
      mail.deliver_now
    end
  end
end
