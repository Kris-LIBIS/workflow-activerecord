require 'libis-workflow'

require_relative 'activerecord/version'
require 'active_record'

module Libis
  module Workflow
    module ActiveRecord

      autoload :Base, 'libis/workflow/activerecord/base'
      autoload :Config, 'libis/workflow/activerecord/config'
      autoload :WorkItem, 'libis/workflow/activerecord/work_item'
      autoload :Run, 'libis/workflow/activerecord/run'
      autoload :Worker, 'libis/workflow/activerecord/worker'
      autoload :Workflow, 'libis/workflow/activerecord/workflow'

      def self.configure
        yield ::Libis::Workflow::ActiveRecord::Config.instance
      end

    end

  end
end
