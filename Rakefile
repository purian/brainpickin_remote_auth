require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "brainpickin_remote_auth"
    gem.summary = %Q{Helper for brainpickin Single Sign In/remote authentication}
    gem.description = %Q{See the README.}
    gem.email = "eli@brainpickin.com"
    gem.homepage = "http://github.com/purian/brainpickin_remote_auth"
    gem.authors = ["Eli Purian"]
    gem.add_dependency "activesupport", ">= 3.0.0"
    gem.add_development_dependency "rspec", ">= 2.6.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
