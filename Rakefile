require 'bundler/gem_tasks'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features)

Cucumber::Rake::Task.new('features:wip', 'Run Cucumber features that are a work in progress') do |t|
  t.profile = 'wip'
end

task :default => :features
