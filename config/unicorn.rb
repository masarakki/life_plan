# config/unicorn.rb
worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true

before_fork do
  Signal.trap 'TERM' do
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do
  Signal.trap 'TERM' do
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
