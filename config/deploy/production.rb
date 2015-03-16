set :rails_env, 'production'
set :domain, "academyclass.com"
set :application, "academyclass"
set :deploy_to, '/home/ubuntu/academyclass'
role :web, '217.174.249.40', user: 'ubuntu'
