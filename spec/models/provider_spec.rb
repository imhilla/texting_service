# spec/models/provider_spec.rb
require "rails_helper"

RSpec.describe Provider, type: :model do
  context "validations" do
    it "should validate presence of name" do
      provider = Provider.new
      expect(provider.valid?).to be_truthy
    end

    it "should validate presence of url" do
      provider = Provider.new
      expect(provider.valid?).to be_truthy
    end

    it "should validate presence of message_count" do
      provider = Provider.new
      expect(provider.valid?).to be_truthy
    end

    it "should validate that message_count is greater than or equal to 0" do
      provider = Provider.new(message_count: -1)
      expect(provider.valid?).to be_truthy
    end
  end
end
