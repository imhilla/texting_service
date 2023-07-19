module SmsSender
  extend ActiveSupport::Concern

  included do
    private

    def send_sms_provider1(to_number, message)
      # Code to send SMS using Provider 1
      print("heeeeeee")
    end

    def send_sms_provider2(to_number, message)
      # Code to send SMS using Provider 2
      print("gheeeeeeeeee")
    end
  end
end
