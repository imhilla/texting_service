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

    def send_sms_provider(to_number, message)
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

      uri = URI.parse(@provider)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      request = Net::HTTP::Post.new(uri.request_uri)
      request.content_type = "application/json"

      call_back_url = "https://5ab8-41-80-118-187.ngrok.io/delivery_status"
      request.body = { to_number: to_number, message: message, callback_url: call_back_url }.to_json
      response = http.request(request)
      if response.is_a?(Net::HTTPSuccess)
        # Successful response
        body = response.body
        update_message_count(@provider_id)
        return { "success" => true, "body" => body }
      else
        # Handle unsuccessful response
        error_message = "Request failed with code #{response.code}"
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

    def render_invalid_number(to_number)
      render json: { message: "Invalid phone number", to_number: to_number }
    end

    def send_sms(to_number, message)
      MessageJob.perform_now(to_number, message)
    end

    def extract_message_id(response)
      JSON.parse(response["body"])["message_id"]
    end

    def create_message(to_number, message, message_id)
      Message.create(to_number: to_number, message: message, message_id: message_id)
    end

    def render_success(to_number, message_id)
      render json: { message: "SMS sent successfully", to_number: to_number, message_id: message_id }
    end

    def render_failure_message(to_number)
      render json: { message: "SMS sending failed for message: #{to_number}" }
    end

    def invalid_details
      render json: { message: "Please provide a valid phone number and message" }
    end
  end
end
