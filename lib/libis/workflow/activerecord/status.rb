require 'libis-workflow-activerecord'

require_relative 'helpers/symbol_serializer'

module Libis
  module Workflow
    module ActiveRecord

      class Status < ::ActiveRecord::Base
        include Libis::Workflow::ActiveRecord::Base

        serialize :status, Libis::Workflow::ActiveRecord::Helpers::SymbolSerializer

        # noinspection RailsParamDefResolve
        belongs_to :work_item, class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s,
                   inverse_of: :status_log,
                   autosave: true
      end

    end
  end
end
