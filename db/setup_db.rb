root_dir = File.join(File.dirname(__FILE__), '..')
Dir.chdir root_dir
$:.unshift File.join(root_dir, 'lib')

require 'libis-workflow-activerecord'
require 'stringio'

::Libis::Workflow::ActiveRecord.configure do |cfg|
  cfg.logger.appenders =
      ::Logging::Appenders.string_io('StringIO', layout: ::Libis::Tools::Config.get_log_formatter)
  # noinspection RubyResolve
  cfg.database_connect 'db/config.yml', :development
end

load 'db/schema.rb'
