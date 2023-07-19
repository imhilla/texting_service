class MessagesController < ApplicationController
  include SmsSender

  def index
  end

  def create
    # get messages/message from json object
    messages = Array(params["messages"])
    if messages
      if messages.empty?
        render json: { message: "Please provide a valid phone number and message" }
      else
        # manual load balancing
        percentage = 0.3
        first_part, second_part = load_balance(messages, percentage)

        first_part.each do |message|
          to_number = message["to_number"]
          content = message["message"]
          send_sms_provider1(to_number, content)
          
        end

        # puts("################################")
        # puts(first_part, "first_partfirst_part")
        # puts("################################")
        # puts(second_part, "second_partsecond_part")
        # send_sms_provider1(to_number, message)
        # print(to_number)
        # print(message)
      end
    else
      render json: { message: "Please provide a valid phone number and message" }
    end
  end
end
