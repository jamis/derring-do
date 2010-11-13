require 'rake'
require 'rake/gempackagetask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

spec = Gem::Specification.new do |s|
    s.platform = Gem::Platform::RUBY
    s.summary = "The over-eager progress monitor."
    s.name = 'derring-do'
    s.version = "1.0.0"
    s.add_development_dependency "rspec ~> 2.1.0"
    s.files = FileList["README.markdown", "Rakefile", "lib/**/*.rb", "spec/**/*.rb", "examples/**/*.rb"].to_a
    s.description = "Derring-Do is a very eager progress monitor for console Ruby applications."
    s.author = "Jamis Buck"
    s.email = "jamis@jamisbuck.org"
    s.homepage = "http://github.com/jamis/derring-do"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

