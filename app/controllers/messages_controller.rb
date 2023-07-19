class MessagesController < ApplicationController
  include SmsSender

  def index
  end

  def create
    to_number = params[:to_number]
    message = params[:message]
    
    send_sms_provider1(to_number, message)
    # print(to_number)
    # print(message)
  end
end
