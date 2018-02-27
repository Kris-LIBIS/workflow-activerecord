require 'libis-workflow-activerecord'

module Libis
  module Workflow
    module ActiveRecord

      class Option < ::ActiveRecord::Base
        include ::Libis::Workflow::ActiveRecord::Base

        # noinspection RailsParamDefResolve
        belongs_to :item, polymorphic: true
      end

    end
  end
end
