module Libis
  module Workflow
    module ActiveRecord
      module Helpers
        class Properties
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

        module PropertyHelper

          def properties
            @property_helper ||= Libis::Workflow::ActiveRecord::Helpers::Property(self)
          end

        end
      end
    end
  end
end