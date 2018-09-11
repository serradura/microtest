require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << '.'
  t.test_files = FileList['./test_runners.rb']
end

desc 'Run tests'
task :default => :test
