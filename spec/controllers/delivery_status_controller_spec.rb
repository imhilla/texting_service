require "rails_helper"

RSpec.describe DeliveryStatusController, type: :controller do
  describe "POST #create" do
    let(:message) { create(:message) } # Assuming you have a Message factory set up

    context "with valid params" do
      let(:valid_params) do
        {
          delivery_status: {
            status: "delivered",
            message_id: message.message_id,
          },
        }
      end

      it "updates existing message status" do
        expect do
          post :create, params: valid_params
        end.to change { message.reload.status }.from(nil).to("delivered")
      end

      it "creates a new delivery status" do
        expect do
          post :create, params: valid_params
        end.to change(DeliveryStatus, :count).by(1)
      end

      it "renders a successful JSON response" do
        post :create, params: valid_params
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["message"]).to eq("SMS delivery status saved successfully.")
      end
    end

    # context "with invalid params" do
    #   let(:invalid_params) do
    #     {
    #       delivery_status: {
    #         status: "invalid_status",
    #         message_id: message.message_id,
    #       },
    #     }
    #   end

    #   it "does not update existing message status" do
    #     expect do
    #       post :create, params: invalid_params
    #     end.not_to change { message.reload.status }
    #   end

    #   it "does not create a new delivery status" do
    #     expect do
    #       post :create, params: invalid_params
    #     end.not_to change(DeliveryStatus, :count)
    #   end

    #   it "renders an error JSON response" do
    #     post :create, params: invalid_params
    #     expect(response).to have_http_status(:unprocessable_entity)
    #     expect(JSON.parse(response.body)["message"]).to eq("SMS not saved successfully.")
    #   end
    # end
  end
end
