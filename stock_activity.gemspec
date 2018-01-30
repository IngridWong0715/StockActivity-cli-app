
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stock_activity/version"

Gem::Specification.new do |spec|
  spec.name          = "stock_activity"
  spec.version       = StockActivity::VERSION
  spec.authors       = ["<ingridwong0715>"]
  spec.email         = ["<ingrid830715@gmail.com>"]

  spec.summary       = "This gem goes to Nasdaq"
  spec.homepage      = "https://github.com/IngridWong0715/StockActivity-cli-app"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "nokogiri"
  spec.add_dependency "colorize"

end
