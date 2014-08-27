# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

module Rake
  module DSL
  end
end

require File.expand_path('../config/application', __FILE__)
require 'rake'

Academyclass::Application.load_tasks
