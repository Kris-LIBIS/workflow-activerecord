require 'fileutils'
require 'libis/workflow/base/run'

module Libis
  module Workflow
    module ActiveRecord

      class Run < Libis::Workflow::ActiveRecord::WorkItem

        include ::Libis::Workflow::Base::Run

        property_field :start_date, type: Time, default: lambda {Time.now}
        property_field :log_to_file, type: TrueClass, default: false
        property_field :log_level, default: 'INFO'
        property_field :log_filename
        property_field :run_name

        # noinspection RailsParamDefResolve
        belongs_to :job, class_name: Libis::Workflow::ActiveRecord::Job.to_s,
                 autosave: true

        set_callback(:destroy, :before) do |run|
          run.rm_workdir
          run.rm_log
        end

        def rm_log
          # noinspection RubyResolve
          log_file = self.log_filename
          FileUtils.rm(log_file) if log_file && !log_file.blank? && File.exist?(log_file)
        end

        def rm_workdir
          workdir = self.work_dir
          FileUtils.rmtree workdir if workdir && !workdir.blank? && Dir.exist?(workdir)
        end

        def work_dir
          # noinspection RubyResolve
          dir = File.join(Libis::Workflow::Config.workdir, self.id.to_s)
          FileUtils.mkpath dir unless Dir.exist?(dir)
          dir
        end

        def run(action = :run)
          self.start_date = Time.now
          self.tasks = []
          super action
          close_logger
        end

        def logger
          # noinspection RubyResolve
          unless self.log_to_file
            return self.job.logger
          end
          logger = ::Logging::Repository.instance[self.name]
          return logger if logger
          unless ::Logging::Appenders[self.name]
            # noinspection RubyResolve
            self.log_filename ||= File.join(::Libis::Workflow::ActiveRecord::Config[:log_dir], "#{self.name}-#{self.id}.log")
            # noinspection RubyResolve
            ::Logging::Appenders::File.new(
                self.name,
                filename: self.log_filename,
                layout: ::Libis::Workflow::ActiveRecord::Config.get_log_formatter,
                level: self.log_level
            )
          end
          logger = ::Libis::Workflow::ActiveRecord::Config.logger(self.name, self.name)
          logger.additive = false
          # noinspection RubyResolve
          logger.level = self.log_level
          logger
        end

        def close_logger
          # noinspection RubyResolve
          return unless self.log_to_file
          ::Logging::Appenders[self.name].close
          ::Logging::Appenders.remove(self.name)
          ::Logging::Repository.instance.delete(self.name)
        end

        def name
          parts = [self.job.name]
          parts << self.run_name unless self.run_name.blank?
          parts << self.created_at.strftime('%Y%m%d-%H%M%S')
          parts << self.id.to_s if self.run_name.blank?
          parts.join('-')
        rescue
          self.id.to_s
        end

      end

    end
  end
end
