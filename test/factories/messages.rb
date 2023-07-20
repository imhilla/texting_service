FactoryBot.define do
  factory :message do
    message_id { SecureRandom.uuid }
  end
end
