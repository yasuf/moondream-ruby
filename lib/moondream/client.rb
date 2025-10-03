# frozen_string_literal: true

require_relative "version"
require "httparty"
require "net/http"
require "json"

module Moondream
  class Error < StandardError; end

  class Client
    attr_reader :api_key

    BASE_URL = "https://api.moondream.ai/v1"

    def initialize(api_key:)
      @api_key = api_key
    end

    def query(image_url, prompt)
      response = HTTParty.post(
        "#{BASE_URL}/query",
        body: { image_url: image_url, prompt: prompt },
        headers: { "Authorization" => "Bearer #{api_key}" }
      )

      response.body
    end

    def detect(image_url, object)
      response = HTTParty.post(
        "#{BASE_URL}/detect",
        body: { image_url: image_url, object: object },
        headers: { "Authorization" => "Bearer #{api_key}" }
      )

      response.body
    end

    def point(image_url, object)
      response = HTTParty.post(
        "#{BASE_URL}/point",
        body: { image_url: image_url, object: object },
        headers: { "Authorization" => "Bearer #{api_key}" }
      )

      response.body
    end

    # In this method, we're using the native Net::HTTP so that the stream support can be supported.
    # The usage of this function if stream=true is:
    # client = Moondream::Client.new(api_key: "your_api_key")
    # client.caption("https://example.com/image.jpg", "normal", true) do |response|
    #   response.read_body do |chunk|
    #     puts chunk # or do something else with the chunk
    #   end
    # end
    def caption(image_url, length = "normal", stream = false)
      uri = URI("#{BASE_URL}/caption")

      result = nil
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        request = Net::HTTP::Post.new(uri)
        request["Authorization"] = "Bearer #{api_key}"
        request["Content-Type"] = "application/json"
        request.body = { image_url: image_url, length: length, stream: stream }.to_json

        http.request(request) do |response|
          yield response if stream && block_given?
          result = response.body
        end
      end
      result
    end
  end
end
