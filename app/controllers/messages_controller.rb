class MessagesController < ApplicationController
  include SmsSender

  def create
    to_number = message_params[:to_number]
    message = message_params[:message]

    if message.blank? || to_number.blank?
      invalid_details
      return
    end

    existing_message_found = Message.find_by(to_number: to_number)

    if existing_message_found&.status == "invalid"
      render_invalid_number(to_number)
    else
      success = send_sms(to_number, message)
      if success["success"]
        message_id = extract_message_id(success)

        create_message(to_number, message, message_id)
        render_success(to_number, message_id)
      else
        render_failure_message(to_number)
      end
    end
  end

  private

  def message_params
    params.permit(:to_number, :message, :message_id, :status)
  end
end
