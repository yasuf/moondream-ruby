require_relative 'lib/moondream/version'

Gem::Specification.new do |spec|
  spec.name          = "moondream"
  spec.version       = Moondream::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "Ruby client for Moondream"
  spec.description   = "A Ruby gem for interacting with Moondream"
  spec.homepage      = "https://github.com/yourusername/moondream-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/moondream-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/moondream-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  # spec.add_dependency "http", "~> 5.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end

