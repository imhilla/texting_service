require "rails_helper"

RSpec.describe MessagesController, type: :controller do
  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { { to_number: "+1234567890", message: "Test message" } }

      it "calls the invalid_details method when both to_number and message are blank" do
        allow(controller).to receive(:invalid_details)

        post :create, params: { to_number: "", message: "" }

        expect(controller).to have_received(:invalid_details)
      end

      it "calls the invalid_details method when to_number is blank" do
        allow(controller).to receive(:invalid_details)

        post :create, params: { to_number: "", message: "Test message" }

        expect(controller).to have_received(:invalid_details)
      end

      it "calls the invalid_details method when message is blank" do
        allow(controller).to receive(:invalid_details)

        post :create, params: { to_number: "+1234567890", message: "" }

        expect(controller).to have_received(:invalid_details)
      end
    end
  end
end
