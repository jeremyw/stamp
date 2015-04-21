require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'rake/testtask'

Cucumber::Rake::Task.new(:features)

Cucumber::Rake::Task.new('features:wip', 'Run Cucumber features that are a work in progress') do |t|
  t.profile = 'wip'
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
end

task :default => [:test, :features]
