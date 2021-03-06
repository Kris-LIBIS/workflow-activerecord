require 'libis/workflow/base/job'
require 'libis/workflow/activerecord/base'

module Libis
  module Workflow
    module ActiveRecord

      class Job < ::ActiveRecord::Base
        include ::Libis::Workflow::Base::Job
        include ::Libis::Workflow::ActiveRecord::Base

        # noinspection RailsParamDefResolve
        has_many :runs, -> {order 'created_at asc'},
                 class_name: Libis::Workflow::ActiveRecord::Run.to_s,
                 foreign_key: :job_id,
                 autosave: true
        # noinspection RailsParamDefResolve
        belongs_to :workflow, class_name: Libis::Workflow::ActiveRecord::Workflow.to_s,
                 autosave: true

        # index({workflow_id: 1, workflow_type: 1, name: 1}, {name: 'by_workflow'})

        def self.from_hash(hash)
          self.create_from_hash(hash, [:name]) do |item, cfg|
            item.workflow = Libis::Workflow::ActiveRecord::Workflow.from_hash(name: cfg.delete('workflow'))
          end
        end

        def logger
          # noinspection RubyResolve
          return ::Libis::Workflow::ActiveRecord::Config.logger unless self.log_to_file
          logger = ::Logging::Repository.instance[self.name]
          return logger if logger
          unless ::Logging::Appenders[self.name]
            ::Logging::Appenders::RollingFile.new(
                self.name,
                filename: File.join(::Libis::Workflow::ActiveRecord::Config[:log_dir], "#{self.name}.{{%Y%m%d}}.log"),
                layout: ::Libis::Workflow::ActiveRecord::Config.get_log_formatter,
                truncate: true,
                age: self.log_age,
                keep: self.log_keep,
                roll_by: 'date',
                level: self.log_level
            )
          end
          logger = ::Libis::Workflow::ActiveRecord::Config.logger(self.name, self.name)
          logger.additive = false
          logger
        end

        # noinspection RubyStringKeysInHashInspection
        def execute(opts = {})
          opts['run_config'] ||= {}
          if self.log_each_run
            opts['run_config']['log_to_file'] = true
            opts['run_config']['log_level'] = self.log_level
          end
          if (run_name = opts.delete('run_name'))
            opts['run_config']['run_name'] = run_name
          end
          super opts
        end

        # def create_run_object
        #   # noinspection RubyResolve
        #   self.runs.build
        # end

      end

    end
  end
end
