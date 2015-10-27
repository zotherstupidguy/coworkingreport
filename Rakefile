require "rake"
require 'rake/testtask'


# task :default => :complete_test
# compelte test depends on flushin db then expecting a certain space upcoming events run the test

Rake::TestTask.new 'test' do |t|
  t.libs = ["lib"]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['spec/*_spec.rb']
end

task 'db:flush' do
  `redis-cli flushall`
  $logger.info("Redis got a flushall")
end

desc 'Complete clean test'
task :complete do
  #ENV['Somevariable'] = 'true'
  Rake::Task['db:info'].execute
  Rake::Task['db:flush'].invoke
  Rake::Task['test'].invoke
end

task 'db:monitor' do 
  `redis-cli monitor`
end

task 'db:info' do
  `redis-cli INFO`
end
