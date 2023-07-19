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

    def load_balance(messages, percentage)
      size = messages.size
      if size == 1
        return [messages, []]
      elsif size == 2
        return [messages[0], messages[1]]
      else
        split_index = (size * percentage).to_i
        first_part = messages[0...split_index]
        second_part = messages[split_index..-1]
        [first_part, second_part]
      end
    end
  end
end
