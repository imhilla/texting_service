require "rails_helper"

RSpec.describe DeliveryStatusController, type: :controller do
  describe "POST #create" do
    let(:message) { create(:message) }

    context "with valid params" do
      let(:valid_params) do
        {
          delivery_status: {
            status: "invalid",
            message_id: message.message_id,
          },
        }
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
  end
end
