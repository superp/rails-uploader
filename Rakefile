# frozen_string_literal: true

require 'rdoc/task'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Generate documentation for the rails-uploader plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Rails Uploader'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
