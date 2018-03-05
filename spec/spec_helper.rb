require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'libis-workflow-activerecord'

require 'database_cleaner'
require 'stringio'

RSpec.configure do |cfg|

  cfg.before :suite do
    # noinspection RubyResolve
    ::Libis::Workflow::ActiveRecord.configure do |cfg|
      cfg.logger.appenders =
          ::Logging::Appenders.string_io('StringIO', layout: ::Libis::Tools::Config.get_log_formatter)
      cfg.itemdir = File.join(File.dirname(__FILE__), 'items')
      cfg.taskdir = File.join(File.dirname(__FILE__), 'tasks')
      cfg.workdir = File.join(File.dirname(__FILE__), 'work')
      cfg.database_connect 'db/config.yml', :test
    end
    DatabaseCleaner.clean_with :truncation
  end

  cfg.before :each do
    # DatabaseCleaner.strategy = :transaction
    # DatabaseCleaner.start
  end

  cfg.after :each do
    # DatabaseCleaner.clean
  end

end