class MessageJob < ApplicationJob
  include SmsSender

  queue_as :default

  def perform(*args)
    to_number = args[0]
    message = args[1]

    send_sms_provider(to_number, message)
  end
end
