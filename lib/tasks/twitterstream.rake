require 'rubygems'
require 'daemons'
require 'win32-process'

desc "Listen to the Twitter stream and capture tweets"
task :listen => [:environment] do
  Daemons.run_proc('twitterstream', ARGV: ['start'], log_output: true) do
    exec "ruby ../twitterstream.rb start"
  end
end