worker_processes 2
timeout 30
preload_app true

before_fork do |server, worker|
  @delayed_job_pid ||= spawn("bundle exec rake listen")

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
    puts 'Unicorn master intercepting TERM and sending TERM to delayed job worker'
    Process.kill 'TERM', @delayed_job_pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
