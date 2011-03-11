require 'bundler'
begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.rcov[:rcov_opts] << "-Ispec"
  end
rescue LoadError
end

RSpec::Core::RakeTask.new :spec
Bundler::GemHelper.install_tasks

desc "Sanitize sensitive info from cassettes"
task :sanitize_cassettes do
  if ENV['WHM_HASH'] && ENV['WHM_HOST']
    path = File.join(File.dirname(__FILE__), 'spec', 'vcr_cassettes')
    files = Dir.glob("#{path}/**/*.yml")
    if files.any?
      files.each do |file|
        old = File.read(file)
        if old.match(/#{ENV['WHM_HASH']}|#{ENV['WHM_HOST']}/)
          puts "Sanitizing #{file}" 
          old.gsub!(ENV['WHM_HASH'], 'iscool')
          old.gsub!(ENV['WHM_HOST'], 'myhost.com')
          File.open(file, 'w') do |f|
            f.write old
          end
        end
      end
    else
      puts "Nothing to sanitize"
    end
  else
    puts "I can't sanitize without setting up WHM_HASH and WHM_HOST"
  end
end

desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
end
