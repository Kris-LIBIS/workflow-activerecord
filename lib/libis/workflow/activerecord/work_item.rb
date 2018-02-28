require 'libis-workflow-activerecord'

require_relative 'helpers/properties'

module Libis
  module Workflow
    module ActiveRecord

      class WorkItem < ::ActiveRecord::Base

        self.table_name = 'work_items'

        include Libis::Workflow::Base::WorkItem
        include Libis::Workflow::ActiveRecord::Base
        include Libis::Workflow::ActiveRecord::Helpers::PropertyHelper

        # noinspection RailsParamDefResolve
        has_many :option_items,
                 class_name: Libis::Workflow::ActiveRecord::Option.to_s,
                 as: :work_item,
                 dependent: :destroy,
                 autosave: true

        # noinspection RailsParamDefResolve
        has_many :property_items,
                 class_name: Libis::Workflow::ActiveRecord::Property.to_s,
                 as: :work_item,
                 dependent: :destroy,
                 autosave: true

        # noinspection RailsParamDefResolve
        has_many :status_entries,
                 as: :work_item,
                 dependent: :destroy,
                 autosave: true

        # noinspection RailsParamDefResolve
        has_many :items,
                 class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s,
                 as: :parent,
                 dependent: :destroy,
                 autosave: true

        # noinspection RailsParamDefResolve
        belongs_to :parent,
                   polymorphic: true


        class PropertyHelper
          attr_reader :item

          def initialize(item)
            @item = item
          end

          def [](key)
            # noinspection RubyResolve
            property = item.property_items.find_by(name: key)
            property&.value
          end

          def []=(key, value)
            # noinspection RubyResolve
            property = item.property_items.find_by(name: key)
            if property
              old_value = property.value
              property.value = value
              return old_value
            end
            nil
          end
        end

        def properties
          @property_helper ||= Helpers::Properties.new(self)
        end

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
          self.status_entries.build(info)
          self.status_entries.last
        end

      end

    end
  end
end
