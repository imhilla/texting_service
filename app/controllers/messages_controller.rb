class MessagesController < ApplicationController
  include SmsSender

  def create
    message_params = params.permit(:to_number, :message, :message_id)
    to_number = message_params[:to_number]
    message = message_params[:message]

    if message.blank? || to_number.blank?
      invalid_details()
      return
    end

    success = send_sms(to_number, message)

    if success["success"]
      message_id = JSON.parse(success["body"])["message_id"]

      Message.create(to_number: to_number, message: message, message_id: message_id)
      render json: { message: "SMS sent successfully", to_number: to_number, message_id: message_id }
    else
      render_failure_message(to_number)
    end
  end

  private

  def send_sms(to_number, message)
    MessageJob.perform_now(to_number, message, first_part: true)
  end
end
