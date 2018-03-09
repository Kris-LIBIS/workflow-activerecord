require 'coveralls'
Coveralls.wear!

# noinspection RubyResolve
require 'bundler/setup'
# noinspection RubyResolve
Bundler.setup

require 'rspec'
require 'libis-workflow-activerecord'

require 'database_cleaner'
require 'stringio'

RSpec.configure do |cfg|

  cfg.before :suite do
    ::Libis::Workflow::ActiveRecord.configure do |config|
      config.logger.appenders =
          ::Logging::Appenders.string_io('StringIO', layout: ::Libis::Tools::Config.get_log_formatter)
      # noinspection RubyResolve
      config.itemdir = File.join(File.dirname(__FILE__), 'items')
      # noinspection RubyResolve
      config.taskdir = File.join(File.dirname(__FILE__), 'tasks')
      # noinspection RubyResolve
      config.workdir = File.join(File.dirname(__FILE__), 'work')
      # noinspection RubyResolve
      config.database_connect 'db/config.yml', :test
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