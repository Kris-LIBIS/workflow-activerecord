require 'active_support/core_ext/hash/indifferent_access'

module Libis
  module Workflow
    module ActiveRecord
      module Helpers

        class HashSerializer

          def self.dump(hash)
            hash
          end

          def self.load(hash)
            (hash || {}).with_indifferent_access
          end

        end

      end
    end
  end
end