require 'bundler'
Bundler.require(:rake)
require 'rake/clean'
require 'cucumber'
require 'cucumber/rake/task'

require 'puppetlabs_spec_helper/rake_tasks'

CLEAN.include('modules', 'spec/fixtures/', 'doc')
CLOBBER.include('.tmp', '.librarian')

task :librarian_spec_prep do
 sh "librarian-puppet install"
end
task :spec_prep => :librarian_spec_prep

task :qa_up do
  desc "Start qa vm"
  sh "vagrant up qa"
end

Cucumber::Rake::Task.new(:qa) do |t|
  desc "Run cucumber tests"
  t.profile = "qa"
  # features_dir = File.dirname(__FILE__)+ "/features"
  # opts = "-f pretty -f junit --out ./target/test-reports/ --tags @smoke_tests"
  # t.cucumber_opts =  "#{features_dir} #{opts}"
end

task :integration => [:spec, :qa_up, :qa]

task :default => [:spec]
