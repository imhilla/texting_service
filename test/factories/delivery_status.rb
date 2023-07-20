FactoryBot.define do
  factory :delivery_status do
    message_id { SecureRandom.uuid }
    status { "invalid" }
    message { "This is a test message" }
  end
end
