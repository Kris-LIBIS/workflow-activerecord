require 'libis-workflow-activerecord'

require_relative 'helpers/hash_serializer'
require_relative 'helpers/status_serializer'

module Libis
  module Workflow
    module ActiveRecord

      class WorkItem < ::ActiveRecord::Base
        include Libis::Workflow::Base::WorkItem
        include Libis::Workflow::ActiveRecord::Base

        self.table_name = 'work_items'
        # noinspection RubyArgCount
        serialize :options, Libis::Workflow::ActiveRecord::Helpers::HashSerializer
        # noinspection RubyArgCount
        serialize :properties, Libis::Workflow::ActiveRecord::Helpers::HashSerializer
        # noinspection RubyArgCount
        serialize :status_log, Libis::Workflow::ActiveRecord::Helpers::StatusSerializer

        # noinspection RailsParamDefResolve
        has_many :items,
                 -> {order('id')},
                 class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s,
                 foreign_key: :parent_id,
                 # dependent: :destroy,
                 autosave: true

        # noinspection RailsParamDefResolve
        belongs_to :parent,
                   class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s

        def add_item(item)
          raise Libis::WorkflowError, 'Trying to add item already linked to another item' unless item.parent.nil?
          super(item)
        end

        def move_item(item)
          new_item = item.dup
          yield new_item, item if block_given?
          new_item.parent = nil
          item.get_items.each {|i| new_item.move_item(i)}
          self.add_item(new_item)
          if item.parent
            item.parent.items.delete(item)
          end
          new_item
        end

        def get_items
          self.items
        end

        def get_item_list
          self.items.to_a
        end

        protected

        def add_status_log(info)
          # noinspection RubyResolve
          self.status_log << info
          self.status_log.last
        end

      end

    end
  end
end
