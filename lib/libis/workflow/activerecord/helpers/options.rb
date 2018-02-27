module Libis
  module Workflow
    module ActiveRecord
      module Helpers
        class Options
          attr_reader :item

          def initialize(item)
            @item = item
          end

          def [](key)
            # noinspection RubyResolve
            option = item.option_items.find_by(name: key)
            option&.value
          end

          def []=(key, value)
            # noinspection RubyResolve
            option = item.option_items.find_by(name: key)
            if option
              old_value = option.value
              option.value = value
              return old_value
            end
            nil
          end

        end

        module OptionHelper

          def properties
            @option_helper ||= Libis::Workflow::ActiveRecord::Helpers::Option(self)
          end

        end
      end
    end
  end
end