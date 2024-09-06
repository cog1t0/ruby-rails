# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

desc 'db_reset'
task :db_reset do
    puts '----- db_reset start -----'
    system('docker-compose exec run rails db:migrate:reset')
    puts '----- db_reset db:migrate:reset finish -----'
    system('docker-compose exec run rails db:seed')
    puts '----- db_reset db:seed finish -----'
    puts '----- db_reset end -----'
end 