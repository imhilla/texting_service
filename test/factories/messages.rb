FactoryBot.define do
  factory :message do
    to_number { "111234567890" }
    message { "Test message" }
    status { "pending" }
    message_id { SecureRandom.uuid }
  end
end
