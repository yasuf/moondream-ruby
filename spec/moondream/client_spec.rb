# frozen_string_literal: true

RSpec.describe Moondream::Client do
  let(:api_key) { "test_api_key_123" }
  let(:client) { described_class.new(api_key: api_key) }
  let(:image_url) { "https://example.com/image.jpg" }
  let(:base_url) { "https://api.moondream.ai/v1" }

  describe "#initialize" do
    it "sets the api_key" do
      expect(client.api_key).to eq(api_key)
    end

    it "requires an api_key parameter" do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end

  describe "#query" do
    let(:prompt) { "What is in this image?" }
    let(:response_body) { '{"request_id": "123", "answer": "A cat sitting on a chair"}' }

    before do
      stub_request(:post, "#{base_url}/query")
        .with(
          body: { image_url: image_url, prompt: prompt },
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
        .to_return(status: 200, body: response_body)
    end

    it "makes a POST request to the query endpoint" do
      client.query(image_url, prompt)

      expect(WebMock).to have_requested(:post, "#{base_url}/query")
        .with(
          body: { image_url: image_url, prompt: prompt },
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
    end

    it "returns the response body" do
      result = client.query(image_url, prompt)
      expect(result).to eq(response_body)
    end

    it "includes the API key in the Authorization header" do
      client.query(image_url, prompt)

      expect(WebMock).to have_requested(:post, "#{base_url}/query")
        .with(headers: { "Authorization" => "Bearer #{api_key}" })
    end
  end

  describe "#detect" do
    let(:object) { "cat" }
    let(:response_body) { '{"request_id": "123", "objects": [{"x_min": 0.2, "y_min": 0.3, "x_max": 0.6, "y_max": 0.8}]}' }

    before do
      stub_request(:post, "#{base_url}/detect")
        .with(
          body: { image_url: image_url, object: object },
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
        .to_return(status: 200, body: response_body)
    end

    it "makes a POST request to the detect endpoint" do
      client.detect(image_url, object)

      expect(WebMock).to have_requested(:post, "#{base_url}/detect")
        .with(
          body: { image_url: image_url, object: object },
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
    end

    it "returns the response body" do
      result = client.detect(image_url, object)
      expect(result).to eq(response_body)
    end

    it "includes the API key in the Authorization header" do
      client.detect(image_url, object)

      expect(WebMock).to have_requested(:post, "#{base_url}/detect")
        .with(headers: { "Authorization" => "Bearer #{api_key}" })
    end
  end

  describe "#point" do
    let(:object) { "cat" }
    let(:response_body) { '{"request_id": "123", "points": [{"x": 50.23, "y": 100.45}]}' }

    before do
      stub_request(:post, "#{base_url}/point")
        .with(
          body: { image_url: image_url, object: object },
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
        .to_return(status: 200, body: response_body)
    end

    it "makes a POST request to the point endpoint" do
      client.point(image_url, object)

      expect(WebMock).to have_requested(:post, "#{base_url}/point")
        .with(
          body: { image_url: image_url, object: object },
          headers: { "Authorization" => "Bearer #{api_key}" }
        )
    end

    it "returns the response body" do
      result = client.point(image_url, object)
      expect(result).to eq(response_body)
    end

    it "includes the API key in the Authorization header" do
      client.point(image_url, object)

      expect(WebMock).to have_requested(:post, "#{base_url}/point")
        .with(headers: { "Authorization" => "Bearer #{api_key}" })
    end
  end

  describe "#caption" do
    let(:length) { "normal" }
    let(:response_body) { '{"caption": "A beautiful sunset over the ocean"}' }

    context "when stream is false" do
      before do
        stub_request(:post, "#{base_url}/caption")
          .with(
            body: { image_url: image_url, length: length, stream: false }.to_json,
            headers: { "Authorization" => "Bearer #{api_key}" }
          )
          .to_return(status: 200, body: response_body)
      end

      it "requires an image_url parameter" do
        expect { client.caption(length: length, stream: false) }.to raise_error(ArgumentError)
      end

      it "makes a POST request to the caption endpoint" do
        client.caption(image_url: image_url, length: length, stream: false)

        expect(WebMock).to have_requested(:post, "#{base_url}/caption")
          .with(
            body: { image_url: image_url, length: length, stream: false }.to_json,
            headers: { "Authorization" => "Bearer #{api_key}" }
          )
      end

      it "returns the response body" do
        result = client.caption(image_url: image_url, length: length, stream: false)
        expect(result).to eq(response_body)
      end

      it "uses 'normal' as default length" do
        stub_request(:post, "#{base_url}/caption")
          .with(
            body: { image_url: image_url, length: "normal", stream: false }.to_json
          )
          .to_return(status: 200, body: response_body)

        client.caption(image_url: image_url)

        expect(WebMock).to have_requested(:post, "#{base_url}/caption")
          .with(body: { image_url: image_url, length: "normal", stream: false }.to_json)
      end
    end

    context "when stream is true" do
      let(:chunk1) { "A beautiful" }
      let(:chunk2) { " sunset" }

      before do
        stub_request(:post, "#{base_url}/caption")
          .with(
            body: { image_url: image_url, length: length, stream: true }.to_json,
            headers: { "Authorization" => "Bearer #{api_key}" }
          )
          .to_return(status: 200, body: "#{chunk1}#{chunk2}")
      end

      it "yields the response for streaming" do
        chunks = []

        client.caption(image_url: image_url, length: length, stream: true) do |response|
          response.read_body do |chunk|
            chunks << chunk
          end
        end

        expect(chunks).not_to be_empty
      end

      it "makes a POST request with stream=true" do
        client.caption(image_url: image_url, length: length, stream: true) { |_response| }

        expect(WebMock).to have_requested(:post, "#{base_url}/caption")
          .with(
            body: { image_url: image_url, length: length, stream: true }.to_json,
            headers: { "Authorization" => "Bearer #{api_key}" }
          )
      end
    end
  end

  describe "error handling" do
    context "when API returns an error" do
      before do
        stub_request(:post, "#{base_url}/query")
          .to_return(status: 401, body: '{"error": "Unauthorized"}')
      end

      it "returns the error response" do
        result = client.query(image_url, "test prompt")
        expect(result).to include("error")
      end
    end

    context "when network error occurs" do
      before do
        stub_request(:post, "#{base_url}/query")
          .to_raise(HTTParty::Error)
      end

      it "raises an HTTParty error" do
        expect do
          client.query(image_url, "test prompt")
        end.to raise_error(HTTParty::Error)
      end
    end
  end
end
