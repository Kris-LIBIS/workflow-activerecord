require 'libis-workflow-activerecord'

module Libis
  module Workflow
    module ActiveRecord

      class WorkItem < ::ActiveRecord::Base

        include Libis::Workflow::Base::WorkItem
        include Libis::Workflow::ActiveRecord::Base

        has_many :options, dependent: :destroy, as: :work_item
        has_many :properties, dependent: :destroy, as: :work_item
        has_many :status_entries, dependent: :destroy, as: :work_item

        has_many :items, as: :parent, class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s,
                 dependent: :destroy, autosave: true, order: :created_at.asc

        belongs_to :parent, polymorphic: true

        def add_item(item)
          raise Libis::WorkflowError, 'Trying to add item already linked to another item' unless item.parent.nil?
          super(item)
        end

        def move_item(item)
          new_item = item.dup
          yield new_item, item if block_given?
          new_item.parent = nil
          item.get_items.each { |i| new_item.move_item(i) }
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
          self.status_entries.build(info)
          self.status_entries.last
        end

      end

    end
  end
end
