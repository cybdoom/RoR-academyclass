set :branch, 'production'
set :rails_env, 'production'
set :domain, "academyclass.com"
set :application, "academyclass"
role :web, 'public.srv-5cwwd.gb1.brightbox.com', user: 'ubuntu'
