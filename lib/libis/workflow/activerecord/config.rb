# noinspection RubyResolve
require 'singleton'
require 'active_record'

require 'libis/workflow/base/logging'

require 'libis/workflow/config'
module Libis
  module Workflow
    module ActiveRecord

      # noinspection RubyConstantNamingConvention
      Config = ::Libis::Workflow::Config

      Config.define_singleton_method(:database_connect) do |config_file = 'db/config.yml', environment = :production|
        # noinspection RubyResolve
        instance.database_connect(config_file, environment)
      end

      Config.send(:define_method, :database_connect) do |config_file = 'db/config.yml', environment = :production|
	      db_config = YAML.load_file(config_file)
        ::ActiveRecord::Base.logger = Libis::Workflow::ActiveRecord::Config.logger
        ::ActiveRecord::Base.establish_connection(db_config[environment.to_s])
      end

      Config[:log_dir] = '.'

    end
  end
end
