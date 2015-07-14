require 'rubygems'
require 'daemons'
root = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
require File.join(root, "config", "environment")
require 'tweetstream'
require File.join(root, "app/models", "post")
require 'obscenity'

desc "Listen to the Twitter stream and capture tweets"
task :listen => [:environment] do
  #  Daemons.run_proc('twitterstream', ARGV: ['run'], log_output: true) do
  #exec "ruby /lib/twitterstream.rb run"
  ENV["RAILS_ENV"] ||= "development"

  puts "Initializing daemon..."

  TweetStream.configure do |config|
    config.consumer_key       = 'MrfLNywoLWfRLh6GmW0C2U4NM'
    config.consumer_secret    = 'GlfgCGzMZDDXc8A3Wb6l3O3QXVhYanFOsgDzyAN2U3IF25f3Zt'
    config.oauth_token        = '18726841-OtsofftJfOWwsz8zvDMsw3KRG9d5fWVz7OxrDSS89'
    config.oauth_token_secret = 'pL3zk9p8uF85wBi48saa6NWCZ6oxzHuGwkcAW7Idf6eXg'
    config.auth_method        = :oauth
  end

  Obscenity.configure do |config|
    config.blacklist = File.join(root, "config", "obscenity.yml")
  end

  terms = ['#earthbound']

  daemon = TweetStream::Daemon.new('tracker', log_output: true, backtrace: true, ARGV: ['run'])

  daemon.on_inited do
    ActiveRecord::Base.connection.reconnect!
    puts "Listening..."
  end

  daemon.on_error do |message|
    puts "on_error: #{message}"
  end

  daemon.on_reconnect do |timeout, retries|
    puts "on_reconnect: #{timeout}, #{retries}"
  end

  daemon.on_limit do |discarded_count|
    puts "on_limit: #{skip_count}"
  end

  daemon.track(terms) do |message|
    initial_rating = Obscenity.profane?(message.text) ? -1 : 1
    Post.create(display_name: message.user.name,
                user_name: message.user.screen_name,
                avatar: message.user.profile_image_uri,
                message_text: message.text,
                message_id: "tw#{message.id}",
                rating: initial_rating)
  end

  #end
end
