set :stage, :development
set :rails_env, 'development'
set :domain, "test.academyclass.com"
set :application, "test.academyclass.com"
set :deploy_to, '/home/ubuntu/test.academyclass.com'
role :web, '217.174.249.40', user: 'ubuntu'
