require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
Bundler.setup

require 'rspec'
require 'libis-workflow-activerecord'

require 'database_cleaner'

RSpec.configure do |cfg|

  cfg.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  cfg.before :each do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  cfg.after :each do
    DatabaseCleaner.clean
  end

end