root = "/home/manage_app/webapp"
working_directory root
pid "/home/manage_app/tmp/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/home/manage_app/tmp/unicorn.sock"
worker_processes 4
timeout 30
