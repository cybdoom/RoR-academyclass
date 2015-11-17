set :stage, :production
set :ssh_options, { :forward_agent => false }
set :branch, :stage
set :rails_env, 'production'
set :domain, "test.academyclass.com"
set :application, "test.academyclass.com"
set :deploy_to, '/home/academyclass/academyclass'
role :web, '217.174.249.40', user: 'academyclass'
