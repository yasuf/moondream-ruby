# frozen_string_literal: true

require_relative "version"
require "httparty"
require "net/http"
require "json"

# This module contains the Moondream client to use the Moondream API
# to run inference on image querying, detection, pointing, and captioning.
module Moondream
  class Error < StandardError; end

  class Client
    attr_reader :api_key

    BASE_URL = "https://api.moondream.ai/v1"

    # @param api_key [String] The API key to use for the client
    # @return [Moondream::Client] The client instance
    def initialize(api_key:)
      @api_key = api_key
    end

    # @param image_url [String] The URL of the image to query
    # @param prompt [String] The prompt to query the image with
    # @return [String] The response from the API
    def query(image_url, prompt)
      response = HTTParty.post(
        "#{BASE_URL}/query",
        body: { image_url: image_url, prompt: prompt },
        headers: { "Authorization" => "Bearer #{api_key}" }
      )

      response.body
    end

    # @param image_url [String] The URL of the image to detect objects in
    # @param object [String] The object to detect in the image
    # @return [String] The response from the API
    def detect(image_url, object)
      response = HTTParty.post(
        "#{BASE_URL}/detect",
        body: { image_url: image_url, object: object },
        headers: { "Authorization" => "Bearer #{api_key}" }
      )

      response.body
    end

    # @param image_url [String] The URL of the image to point to
    # @param object [String] The object to point to in the image
    # @return [String] The response from the API
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
    #
    # @param image_url [String] The URL of the image to caption
    # @param length [String] The length of the caption, "normal" or "short"
    # @param stream [Boolean] Whether to stream the response, default is false
    # @return [String] The response from the API
    def caption(image_url: nil, length: "normal", stream: false)
      if image_url.nil?
        raise ArgumentError, "image_url is required"
      end

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
