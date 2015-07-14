require 'rubygems'
require 'daemons'

desc "Listen to the Twitter stream and capture tweets"
task :listen => [:environment] do
  Daemons.run_proc('twitterstream', ARGV: ['run'], log_output: true) do
    exec "ruby /../twitterstream.rb run"
  end
end