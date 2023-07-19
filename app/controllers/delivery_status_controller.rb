class DeliveryStatusController < ApplicationController
  def create
    @delivery = DeliveryStatus.new(delivery_params)

    if @delivery.save
      render json: { message: "SMS sent successfully." }
    else
      render json: { message: "SMS not sent successfully" }
    end
  end

  private

  def delivery_params
    permitted_params = params.require(:delivery_status).permit(:status, :message_id)
    permitted_params
  end
end

# ngrok https://gist.github.com/SalahHamza/799cac56b8c2cd20e6bfeb8886f18455
