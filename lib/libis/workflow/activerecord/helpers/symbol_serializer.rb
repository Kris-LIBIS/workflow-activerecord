module Libis
  module Workflow
    module ActiveRecord
      module Helpers

        class SymbolSerializer

          def self.dump(value)
            value&.to_s rescue nil
          end

          def self.load(value)
            value&.to_sym rescue nil
          end

        end

      end
    end
  end
end