##########################################################
##########################################################
##                _____      _                          ##
##               | ___ \    | |                         ##
##               | |_/ /__ _| | _____                   ##
##               |    // _` | |/ / _ \                  ##
##               | |\ \ (_| |   <  __/                  ##
##               \_| \_\__,_|_|\_\___|                  ##
##                                                      ##
##########################################################
##########################################################

# => Libs
require 'sinatra/activerecord/rake'   # => This works but ONLY if you call "bundle exec" - https://github.com/janko/sinatra-activerecord/issues/40#issuecomment-51647819
require 'sinatra/asset_pipeline/task' # => Sinatra Asset Pipeline
require 'rake/testtask'

# => App
# => Loads environment etc
require_relative 'app/app'

##########################################################
##########################################################

Sinatra::AssetPipeline::Task.define! App # => Sinatra Asset Pipeline

##########################################################
##########################################################

task :creds2heroku do
  Bundler.with_clean_env do
    File.readlines('.env').each do |var|
      pipe = IO.popen("heroku config:set #{var}")
      while (line = pipe.gets)
        print line
      end
    end
  end
end

task :deploy2heroku do
  pipe = IO.popen('git push heroku master --force')
  while (line = pipe.gets)
    print line
  end
end

namespace :test do
  task :prepare do
    `RACK_ENV=test rake db:create`
    `RACK_ENV=test rake db:migrate`
    `RACK_ENV=test SECRET=secret rake db:seed`
  end
end

task :test do
  Rake::TestTask.new do |t|
    t.pattern = 'test/*_test.rb'
    t.libs << 'test'
    t.verbose = true
  end
end

##########################################################
##########################################################
