$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "oauth-activeresource/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "oauth-activeresource"
  s.version     = OauthActiveResource::VERSION
  s.authors     = ["Alberto Pastor"]
  s.email       = ["albert.pastor@gmail.com"]
  s.homepage    = ""
  s.summary     = "Rails gem that allows you to easily interact with an Oauth secured rest API with the ActiveResource model."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"

  s.add_development_dependency "sqlite3"
end
