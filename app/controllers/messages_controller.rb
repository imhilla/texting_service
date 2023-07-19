class MessagesController < ApplicationController
  include SmsSender

  def index
  end

  def create
    # get messages/message from json object
    messages = params["messages"]
    if messages
      if messages.size == 0
        render json: { message: "Please provide a valid phone number and message" }
      else
        # manual load balancing
        percentage = 0.3
        first_part, second_part = load_balance(messages, percentage)

        puts(first_part, "first_partfirst_part")
        # send_sms_provider1(to_number, message)
        # print(to_number)
        # print(message)
      end
    else
      render json: { message: "Please provide a valid phone number and message" }
    end
  end
end
