root = "/home/manage_app/webapp"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "#{root}/tmp/unicorn.sock"
worker_processes 4
timeout 30
