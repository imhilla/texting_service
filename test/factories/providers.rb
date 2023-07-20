require "rails_helper"

RSpec.describe ProvidersController, type: :controller do
  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { { provider: { name: "Provider One", message_count: 100, url: "http://example.com" } } }

      it "creates a new provider" do
        expect {
          post :create, params: valid_params
        }.to change(Provider, :count).by(1)
      end

      it "returns a successful response" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "returns the created provider in JSON format" do
        post :create, params: valid_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["name"]).to eq("Provider One")
        expect(parsed_response["message_count"]).to eq(100)
        expect(parsed_response["url"]).to eq("http://example.com")
      end
    end
  end
end
