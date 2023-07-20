require "net/http"
require "uri"
require "json"

module SmsSender
  extend ActiveSupport::Concern

  included do
    private

    def sms_providers
      Provider.all
    end

    def update_message_count(id)
      provider = Provider.find_by(id: id)
      return nil if provider.nil?
      count = provider["message_count"]
      count += 1
      attributes = {
        message_count: count,
      }
      provider.update(attributes)
      if provider.save
        return provider
      else
        return nil
      end
    end

    def send_sms_provider1(to_number, message)
      all_providers = sms_providers
      total_message_count = all_providers.sum { |provider| provider[:message_count] }

      if total_message_count == 0
        @provider, @backup_url, @provider_id, @backup_id = all_providers[0]["url"], all_providers[1]["url"], all_providers[0]["id"], all_providers[1]["url"]
      elsif total_message_count == 1
        @provider, @backup_url, @provider_id, @backup_id = all_providers[1]["url"], all_providers[0]["url"], all_providers[1]["id"], all_providers[0]["url"]
      else
        provider_two_count = total_message_count - all_providers[0]["message_count"]
        provider_two_percentage = (provider_two_count * 100) / total_message_count

        if provider_two_percentage < 70
          @provider, @backup_url, @provider_id, @backup_id = all_providers[1]["url"], all_providers[0]["url"], all_providers[1]["id"], all_providers[0]["url"]
        else
          @provider, @backup_url, @provider_id, @backup_id = all_providers[0]["url"], all_providers[1]["url"], all_providers[0]["id"], all_providers[1]["url"]
        end
      end

      # Code to send SMS using Provider 1
      uri = URI.parse(@provider)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      request = Net::HTTP::Post.new(uri.request_uri)
      request.content_type = "application/json"

      call_back_url = "https://bb33-41-80-118-187.ngrok.io/delivery_status"
      request.body = { to_number: to_number, message: message, callback_url: call_back_url }.to_json
      response = http.request(request)
      puts(request.body, "request.bodyrequest.bodyrequest.bodyrequest.bodyrequest.bodyrequest.bodyrequest.bodyrequest.body")
      if response.is_a?(Net::HTTPSuccess)
        # Successful response
        body = response.body
        update_message_count(@provider_id)
        # Process the response body as needed
        return { "success" => true, "body" => body }
      else
        # Handle unsuccessful response
        error_message = "Request failed with code #{response.code}"
        puts(error_message, "error_messageerror_messageerror_messageerror_messageerror_messageerror_messageerror_messageerror_message")
        # Handle the error message appropriately, use second provider
        uri = URI.parse(@backup_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"

        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = { to_number: to_number, message: message, callback_url: call_back_url }.to_json
        request.content_type = "application/json"

        response = http.request(request)
        if response.is_a?(Net::HTTPSuccess)
          # Successful response
          body = response.body
          update_message_count(@backup_id)
          # Process the response body as needed
          return { "success" => true, "body" => body }
        else
          return { "success" => false, "body" => nil }
        end
      end
    end

    def send_sms_provider2(to_number, message)
      # Code to send SMS using Provider 2
      @provider1 = "https://mock-text-provider.parentsquare.com/provider2"
      @provider2 = "https://mock-text-provider.parentsquare.com/provider1"

      # Code to send SMS using Provider 1
      uri = URI.parse(@provider1)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      request = Net::HTTP::Post.new(uri.request_uri)
      request.content_type = "application/json"
      request.body = { to_number: to_number, message: message, callback_url: "https://b09c-41-80-118-187.ngrok.io/delivery_status" }.to_json
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        # Successful response
        body = response.body
        # Process the response body as needed
        return { "success" => true, "body" => body }
      else
        # Handle unsuccessful response
        error_message = "Request failed with code #{response.code}"
        # Handle the error message appropriately, use second provider
        uri = URI.parse(@provider2)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"

        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = { to_number: to_number, message: message, callback_url: "https://b09c-41-80-118-187.ngrok.io/delivery_status" }.to_json
        request.content_type = "application/json"

        response = http.request(request)
        if response.is_a?(Net::HTTPSuccess)
          # Successful response
          body = response.body
          # Process the response body as needed
          return { "success" => true, "body" => body }
        else
          return { "success" => false, "body" => nil }
        end
      end
    end

    def load_balance(messages, percentage)
      case messages.size
      when 0
        [[], []]
      when 1
        [messages, []]
      when 2
        [messages[0], messages[1]]
      else
        split_index = (messages.size * percentage).to_i
        messages.partition.with_index { |_, index| index < split_index }
      end
    end

    def render_failure_message(to_number)
      render json: { message: "SMS sending failed for message: #{to_number}" }
    end

    def invalid_details
      render json: { message: "Please provide a valid phone number and message" }
    end
  end
end
