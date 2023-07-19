require "net/http"
require "uri"
require "json"

module SmsSender
  extend ActiveSupport::Concern

  included do
    private

    def send_sms_provider1(to_number, message)
      puts("heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
      @provider1 = "https://mock-text-provider.parentsquare.com/provider1"
      @provider2 = "https://mock-text-provider.parentsquare.com/provider2"

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
