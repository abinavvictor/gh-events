unless ENV['RAILS_ENV'] == 'production'.freeze
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new
end
