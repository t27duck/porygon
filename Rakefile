require "bundler"
Bundler.setup

require 'active_record'
include ActiveRecord::Tasks

root = File.expand_path '..', __FILE__
#DatabaseTasks.env = ENV['ENV'] || 'development'
#DatabaseTasks.database_configuration = YAML.load(File.read(File.join(root, 'config/database.yml')))
#DatabaseTasks.fixtures_path = File.join root, 'test/fixtures'
#DatabaseTasks.seed_loader = Seeder.new File.join root, 'db/seeds.rb'
DatabaseTasks.db_dir = File.join root, 'db'
DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
DatabaseTasks.root = root

Dir.glob('./{models}/*.rb').each { |file| require file }

task :environment do
  # ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection YAML.load(File.read(File.join(root, 'config/database.yml')))
end

load 'active_record/railties/databases.rake'
