# Moondream Ruby Client

A Ruby gem for interacting with the [Moondream API](https://moondream.ai), a powerful vision-language model for image understanding. This gem provides a simple interface for querying images, detecting objects, pointing to objects, and generating captions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moondream'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself with:

```bash
$ gem install moondream
```

## Configuration

First, obtain an API key from [Moondream](https://moondream.ai). Then initialize the client:

```ruby
require 'moondream'

client = Moondream::Client.new(api_key: "your_api_key_here")
```

## Usage

### Query an Image

Ask questions about an image using natural language:

```ruby
response = client.query(
  "https://example.com/image.jpg",
  "What is in this image?"
)
puts response
```

### Detect Objects

Detect specific objects in an image and get their locations:

```ruby
response = client.detect(
  "https://example.com/image.jpg",
  "person"
)
puts response
```

### Point to Objects

Get the coordinates of specific objects in an image:

```ruby
response = client.point(
  "https://example.com/image.jpg",
  "the red car"
)
puts response
```

### Generate Captions

Generate descriptive captions for images:

```ruby
# Normal length caption
response = client.caption(
  image_url: "https://example.com/image.jpg",
  length: "normal"
)
puts response

# Short caption
response = client.caption(
  image_url: "https://example.com/image.jpg",
  length: "short"
)
puts response
```

### Streaming Captions

For real-time caption generation, you can use streaming mode:

```ruby
client.caption(
  image_url: "https://example.com/image.jpg",
  length: "normal",
  stream: true
) do |response|
  response.read_body do |chunk|
    print chunk
  end
end
```

## API Methods

### `initialize(api_key:)`

Creates a new Moondream client instance.

**Parameters:**
- `api_key` (String, required): Your Moondream API key

### `query(image_url, prompt)`

Query an image with a natural language prompt.

**Parameters:**
- `image_url` (String): URL of the image to analyze
- `prompt` (String): The question or prompt about the image

**Returns:** String response from the API

### `detect(image_url, object)`

Detect objects in an image.

**Parameters:**
- `image_url` (String): URL of the image to analyze
- `object` (String): The object to detect

**Returns:** String response from the API with detection results

### `point(image_url, object)`

Get coordinates pointing to specific objects in an image.

**Parameters:**
- `image_url` (String): URL of the image to analyze
- `object` (String): The object to point to

**Returns:** String response from the API with coordinate information

### `caption(image_url:, length:, stream:)`

Generate a caption for an image.

**Parameters:**
- `image_url` (String, required): URL of the image to caption
- `length` (String, optional): Caption length - "normal" or "short" (default: "normal")
- `stream` (Boolean, optional): Enable streaming mode (default: false)

**Returns:** String response from the API, or yields response chunks if streaming with a block

## Error Handling

The gem raises `Moondream::Error` for API-related errors. Wrap your calls in error handling:

```ruby
begin
  response = client.query(image_url, prompt)
  puts response
rescue Moondream::Error => e
  puts "Error: #{e.message}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/moondream-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

