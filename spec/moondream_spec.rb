# frozen_string_literal: true

RSpec.describe Moondream do
  it "has a version number" do
    expect(Moondream::VERSION).not_to be nil
  end

  it "defines the Error class" do
    expect(Moondream::Error).to be < StandardError
  end

  it "defines the Client class" do
    expect(Moondream::Client).to be_a(Class)
  end
end
