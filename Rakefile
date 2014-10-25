require 'bundler'
Bundler.require(:rake)
require 'rake/clean'
require 'cucumber'
require 'cucumber/rake/task'

require 'puppetlabs_spec_helper/rake_tasks'

CLEAN.include('modules/*', 'spec/fixtures/', 'doc')
CLOBBER.include('.tmp', '.librarian')

task :librarian_spec_prep do
 sh "librarian-puppet install"
end
task :spec_prep => :librarian_spec_prep

RSpec::Core::RakeTask.new(:beaker) do |c|
  c.pattern = "spec/acceptance/**/*_spec.rb"
end

Cucumber::Rake::Task.new(:qa) do |t|
  FileUtils.mkdir_p("./target")
  desc "Run cucumber tests"
  t.profile = "qa"
  t.cucumber_opts =  "-f pretty -f html --out ./target/cucumber.html -f junit --out ./target/test-reports/"
end

task :integration => [:spec, :qa]

task :default => [:spec]
