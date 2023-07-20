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

  def render_invalid_number(to_number)
    render json: { message: "Invalid phone number", to_number: to_number }
  end

  def send_sms(to_number, message)
    MessageJob.perform_now(to_number, message, first_part: true)
  end

  def extract_message_id(response)
    JSON.parse(response["body"])["message_id"]
  end

  def create_message(to_number, message, message_id)
    Message.create(to_number: to_number, message: message, message_id: message_id)
  end

  def render_success(to_number, message_id)
    render json: { message: "SMS sent successfully", to_number: to_number, message_id: message_id }
  end
end
