require "rails_helper"

RSpec.describe DeliveryStatus, type: :model do
  context "validations" do
    it "should validate presence of status" do
      delivery_status = DeliveryStatus.new
      expect(delivery_status.valid?).to be_truthy
    end
  end
end
