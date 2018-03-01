require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

desc 'run tests'
task :default => :spec

require 'yaml'
require 'logger'
require 'active_record'

namespace :db do
  def create_database(config)
    options = {:charset => 'utf8', :collation => 'utf8_unicode_ci'}

    create_db = lambda do |cfg|
      ActiveRecord::Base.establish_connection cfg.merge('database' => nil)
      ActiveRecord::Base.connection.create_database cfg['database'], options
      ActiveRecord::Base.establish_connection cfg
    end

    begin
      create_db.call config
      # rescue Mysql::Error => sqlerr
      #   if sqlerr.errno == 1405
      #     print "#{sqlerr.error}. \nPlease provide the root password for your mysql installation\n>"
      #     root_password = $stdin.gets.strip
      #
      #     grant_statement = <<-SQL
      #       GRANT ALL PRIVILEGES ON #{config['database']}.*
      #         TO '#{config['username']}'@'localhost'
      #         IDENTIFIED BY '#{config['password']}' WITH GRANT OPTION;
      #     SQL
      #
      #     create_db.call config.merge('database' => nil, 'username' => 'root', 'password' => root_password)
      #   else
      #     $stderr.puts sqlerr.error
      #     $stderr.puts "Couldn't create database for #{config.inspect}, charset: utf8, collation: utf8_unicode_ci"
      #     $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config['charset']
      #   end
    end
  end

  task :environment do
    DATABASE_ENV = ENV['DATABASE_ENV'] || 'development'
    MIGRATIONS_DIR = ENV['MIGRATIONS_DIR'] || 'db/migrate'
  end

  task :configuration => :environment do
    @config = YAML.load_file('db/config.yml')[DATABASE_ENV]
  end

  task :configure_connection => :configuration do
    ActiveRecord::Base.establish_connection @config
    ActiveRecord::Base.logger = Logger.new STDOUT if @config['logger']
  end

  desc 'Create the database from db/config.yml for the current DATABASE_ENV'
  task :create => :configure_connection do
    create_database @config
  end

  desc 'Drops the database for the current DATABASE_ENV'
  task :drop => :configure_connection do
    ActiveRecord::Base.connection.drop_database @config['database']
  end

  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task :migrate => :configure_connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback => :configure_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end

  desc 'Retrieves the current schema version number'
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end
end
