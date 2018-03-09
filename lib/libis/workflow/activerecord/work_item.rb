require 'active_support/core_ext/hash/indifferent_access'
require 'libis-workflow-activerecord'

require_relative 'helpers/hash_serializer'
require_relative 'helpers/status_serializer'
require_relative 'helpers/property_helper'

module Libis
  module Workflow
    module ActiveRecord

      class WorkItem < ::ActiveRecord::Base
        include Libis::Workflow::Base::WorkItem
        include Libis::Workflow::ActiveRecord::Base
        include Libis::Workflow::ActiveRecord::Helpers::PropertyHelper

        self.table_name = 'work_items'
        # noinspection RubyArgCount
        serialize :options, Libis::Workflow::ActiveRecord::Helpers::HashSerializer
        # noinspection RubyArgCount
        serialize :properties, Libis::Workflow::ActiveRecord::Helpers::HashSerializer
        # noinspection RubyArgCount
        # serialize :status_log, Libis::Workflow::ActiveRecord::Helpers::StatusSerializer
        #
        # noinspection RailsParamDefResolve
        has_many :status_log,
                 -> {order('id')},
                 class_name: Libis::Workflow::ActiveRecord::Status.to_s,
                 foreign_key: :work_item_id,
                 autosave: true

        # noinspection RailsParamDefResolve
        has_many :items,
                 -> {order('id')},
                 class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s,
                 foreign_key: :parent_id,
                 autosave: true

        # noinspection RailsParamDefResolve
        belongs_to :parent, class_name: Libis::Workflow::ActiveRecord::WorkItem.to_s,
                   inverse_of: :items,
                   autosave: true

        def add_item(item)
          raise Libis::WorkflowError, 'Trying to add item already linked to another item' unless item.parent.nil?
          super(item)
        end

        def duplicate
          new_item = self.class.new
          new_item.properties = {}.with_indifferent_access
          self.properties.each {|k, v| new_item.properties[k.to_sym] = v.dup}
          new_item.options = {}.with_indifferent_access
          self.options.each {|k, v| new_item.options[k.to_sym] = v.dup}
          yield new_item if block_given?
          new_item
        end

        def copy_item(item, &block)
          new_item = item.duplicate &block
          new_item.parent = nil
          add_item new_item
          item.items.each {|i| new_item.copy_item(i)}
          new_item
        end

        def move_item(item)
          old_parent = item.parent
          item.parent = self
          item.save
          old_parent.items.reset
          self.items.reset
          item
        end

        def get_items
          self.items.order(:id)
        end

        def get_item_list
          get_items.to_a
        end

        protected

        def save_log_entry(log_entry)
          log_entry.save!
          self.reload
        end

        def status_entry(task = nil)
          task = task.namepath if task.is_a?(Libis::Workflow::Task)
          return self.status_log.order(id: :asc).last if task.blank?
          self.status_log.where(task: task).order(id: :asc).last
        rescue Exception
          nil
        end

        def add_status_log(info)
          self.status_log.build(info)
          self.status_log.last
          # noinspection RubyResolve
          # self.status_log << info.with_indifferent_access
          # self.status_log.last
        end

      end

    end
  end
end
