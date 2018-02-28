require 'libis-workflow-activerecord'

module Libis
  module Workflow
    module Activerecord

      class StatusEntry < ::ActiveRecord::Base
        include ::Libis::Workflow::ActiveRecord::Base

        belongs_to :work_item, polymorphic: true
      end

    end
  end
end
