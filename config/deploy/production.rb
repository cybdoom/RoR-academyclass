set :rails_env, 'production'
set :domain, "academyclass.com"
set :application, "academyclass"
set :deploy_to, '/home/ubuntu/academyclass'
role :web, '109.107.35.66', user: 'ubuntu'
