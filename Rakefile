require 'bundler'
Bundler.require(:rake)
require 'rake/clean'

require 'puppetlabs_spec_helper/rake_tasks'

CLEAN.include('modules', 'spec/fixtures/', 'doc')
CLOBBER.include('.tmp', '.librarian')

task :librarian_spec_prep do
 sh "librarian-puppet install"
end
task :spec_prep => :librarian_spec_prep

task :default => [:spec]
