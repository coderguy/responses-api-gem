require_relative 'form_request'
require 'open-uri'
require 'hashie'
Hash.send :include, Hashie::Extensions

module ResponsesApi
  class RetrieveFile < FormRequest
    ISO_8601_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

    def initialize(form_id, response_id, field_id, filename, token: APIConfig.token)
      url = "#{APIConfig.api_request_url}/forms/#{form_id}/responses/#{response_id}/fields/#{field_id}/files/#{filename}?"
      r = {
        method: :get,
        url: url
      }
      r[:headers] = { 'Authorization' => "Bearer #{token}" } unless token.nil?

      request(r)
    end

    def success?
      @response.code == 200 && json?
    end

    def responses(hashie: true)
      if hashie
        Hashie::Mash.new(json).items
      else
        json.fetch(:items)
      end
    end

    def page_count
      json.fetch(:page_count)
    end

    def total_items
      json.fetch(:total_items)
    end
  end
end
