class MessagesController < ApplicationController
  include SmsSender

  def create
    # get messages/message from json object
    messages = Array(params["messages"])

    if messages.nil? || messages.empty?
      invalid_details()
      return
    end

    # manual load balancing
    percentage = 0.3
    first_part, second_part = load_balance(messages, percentage)

    first_part.each do |message|
      to_number = message["to_number"]
      message = message["message"]
      response = send_sms_provider1(to_number, message)

      if response["success"]
        Message.create(to_number: to_number, message: message, message_id: response["message_id"])
      else
        render_failure_message(to_number)
        break
      end
    end

    # second_part.each do |message|
    #   to_number = message["to_number"]
    #   message = message["message"]
    #   response = send_sms_provider2(to_number, message)

    #   if response["success"]
    #     Message.create(to_number: to_number, message: message, message_id: response["message_id"])
    #   else
    #     render_failure_message(to_number)
    #     break
    #   end
    # end
  end
end
