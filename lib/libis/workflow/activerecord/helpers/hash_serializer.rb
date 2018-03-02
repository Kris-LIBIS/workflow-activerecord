require 'active_support/core_ext/hash/indifferent_access'
require 'libis/tools/extend/hash'

module Libis
  module Workflow
    module ActiveRecord
      module Helpers

        class HashSerializer

          def self.dump(hash)
            delete_proc = Proc.new do |_, v|
              # Cleanup the hash recursively and remove entries with value == nil
              # noinspection RubyScope
              v.delete_if(&delete_proc) if v.kind_of?(Hash)
              v.nil?
            end
            hash.delete_if &delete_proc if hash.is_a?(Hash)
            # Store a nil value if the hash is empty
            (hash.is_a?(Hash) && !hash.empty?) ? hash : nil
          end

          def self.load(hash)
            (hash || {}).with_indifferent_access
          end

        end

      end
    end
  end
end