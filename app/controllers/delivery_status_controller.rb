class DeliveryStatusController < ApplicationController
  def create
    @delivery = DeliveryStatus.new(delivery_params)
    message_id = delivery_params[:message_id]
    existing_message = Message.find_by(message_id: message_id)

    if existing_message
      existing_message.update(status: delivery_params[:status])
    end

    if @delivery.save
      render json: { message: "SMS delivery status saved successfully." }
    else
      render json: { message: "SMS not saved successfully." }
    end
  end

  private

  def delivery_params
    permitted_params = params.require(:delivery_status).permit(:status, :message_id)
    permitted_params
  end
  
end
