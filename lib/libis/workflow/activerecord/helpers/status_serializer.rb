require 'active_support/core_ext/hash/indifferent_access'

module Libis
  module Workflow
    module ActiveRecord
      module Helpers

        class StatusSerializer

          def self.dump(array)
            return nil unless array.is_a?(Array) && !array.empty?
            array || []
          end

          def self.load(array)
            (array || []).map do |status|
              status = status.with_indifferent_access
              status[:status] = status[:status].to_sym if status.has_key? :status
              status[:created] = DateTime.parse(status[:created]) if status.has_key? :created
              status[:updated] = DateTime.parse(status[:updated]) if status.has_key? :updated
              status
            end
          end

        end

      end
    end
  end
end