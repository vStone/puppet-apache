require 'rake'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'

# provide split out tasks for functions/classes/...
SPEC_SUITES = (Dir.entries('spec') - ['.', '..','fixtures','lib']).select {|e| File.directory? "spec/#{e}" }
namespace :test do
  SPEC_SUITES.each do |suite|
    desc "Run #{suite} RSpec code examples"
    RSpec::Core::RakeTask.new(suite => :spec_prep) do |t|
      t.pattern= "spec/#{suite}/**/*_spec.rb"
      t.rspec_opts = File.read("spec/spec.opts").chomp || ""
    end
    Rake::Task[suite].enhance do
      Rake::Task[:spec_clean].invoke
    end
  end
end

RSpec::Core::RakeTask.new(:spec_verbose) do |t|
  t.pattern = 'spec/*/*_spec.rb'
  t.rspec_opts = File.read('spec/spec.opts').chomp || ""
end

task :test do
  Rake::Task[:spec_prep].invoke
  Rake::Task[:spec_verbose].invoke
  Rake::Task[:spec_clean].invoke
end


# Default task
task :default => :rspec
