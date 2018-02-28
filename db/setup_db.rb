root_dir = File.join(File.dirname(__FILE__), '..')
Dir.chdir root_dir
$:.unshift File.join(root_dir, 'lib')

require 'libis-workflow-activerecord'

::Libis::Workflow::ActiveRecord.configure do |cfg|
  # noinspection RubyResolve
  cfg.database_connect 'db/config.yml', :test
end

require 'database_cleaner'

load 'db/schema.rb'
