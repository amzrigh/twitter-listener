ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(root, "config", "environment")

require 'tweetstream'

puts "Initializing daemon..."

TweetStream.configure do |config|
  config.consumer_key       = 'MrfLNywoLWfRLh6GmW0C2U4NM'
  config.consumer_secret    = 'GlfgCGzMZDDXc8A3Wb6l3O3QXVhYanFOsgDzyAN2U3IF25f3Zt'
  config.oauth_token        = '18726841-OtsofftJfOWwsz8zvDMsw3KRG9d5fWVz7OxrDSS89'
  config.oauth_token_secret = 'pL3zk9p8uF85wBi48saa6NWCZ6oxzHuGwkcAW7Idf6eXg'
  config.auth_method        = :oauth
end

terms = ['#thisismyhashtag']

daemon = TweetStream::Daemon.new('tracker', log_output: true, backtrace: true)

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

daemon.track(terms) do |msg|
  Post.create(msg.user.screen_name
  msg.user.name
  msg.text
  msg.id
end