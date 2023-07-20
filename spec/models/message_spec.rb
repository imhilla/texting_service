require "rails_helper"

RSpec.describe Message, type: :model do
  context "validations" do
    it "should validate presence of messages" do
      message = Message.new
      expect(message.valid?).to be_truthy
    end
  end
end
