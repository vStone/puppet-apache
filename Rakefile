require 'bundler'
Bundler.require(:rake)
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet_blacksmith/rake_tasks'
require 'rake/clean'

CLEAN.include('doc', 'pkg', 'spec/fixtures')

# provide split out tasks for functions/classes/...
namespace :test do
  ["classes","functions"].each do |suite|
    desc "Run #{suite} RSpec code examples"
    RSpec::Core::RakeTask.new(suite => :spec_prep) do |t|
      t.pattern= "spec/#{suite}/**/*_spec.rb"
    end
    Rake::Task[suite].enhance do
      Rake::Task[:spec_clean].invoke
    end
  end
end

# Default task
task :default => :spec
