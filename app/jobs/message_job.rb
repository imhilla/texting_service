class MessageJob < ApplicationJob
  include SmsSender

  queue_as :default

  def perform(*args)
    to_number = args[0]
    message = args[1]
    first_part = args[2]

    if first_part
      send_sms_provider1(to_number, message)
    else
      send_sms_provider2(to_number, message)
    end
  end
end
