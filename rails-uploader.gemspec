# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "uploader/version"

Gem::Specification.new do |s|
  s.name = "rails-uploader"
  s.version = Uploader::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary = "Rails file upload implementation with jQuery-File-Upload"
  s.description = "Rails HTML5 FileUpload helpers"
  s.authors = ["Igor Galeta", "Pavlo Galeta"]
  s.email = "superp1987@gmail.com"
  s.rubyforge_project = "rails-uploader"
  s.homepage = "https://github.com/superp/rails-uploader"

  s.files = Dir["{app,lib,config,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["{spec}/**/*"]
  s.extra_rdoc_files = ["README.md"]
  s.require_paths = ["lib"]

  s.add_dependency 'jquery-ui-rails'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'carrierwave'
  s.add_development_dependency 'mongoid'
end
