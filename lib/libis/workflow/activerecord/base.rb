require 'yaml'
require 'libis/tools/extend/hash'

module Libis
  module Workflow
    module ActiveRecord

      module Base

        def self.included(klass)
          klass.extend(ClassMethods)

          # def [](key)
          #   self.send(key.to_sym)
          # end
          #
          # def []=(key,value)
          #   self.send(key.to_s + '=', value)
          # end
        end

        module ClassMethods
          def from_hash(hash)
            self.create_from_hash(hash.cleanup, [:name])
          end

          def create_from_hash(hash, id_tags, &block)
            hash = hash.key_symbols_to_strings(recursive: true)
            id_tags = id_tags.map(&:to_s)
            return nil unless id_tags.empty? || id_tags.any? { |k| hash.include?(k) }
            tags = id_tags.inject({}) do |h, k|
              v = hash.delete(k)
              h[k] = v if v
              h
            end
            item = tags.empty? ? self.new : self.find_or_initialize_by(tags)
            block.call(item, hash) if block unless hash.empty?
            item.assign_attributes(hash)
            item.save!
            item
          end

        end

        def to_hash
          result = self.attributes.reject { |k, v| v.blank? || volatile_attributes.include?(k) }
          result = result.to_yaml.gsub(/!ruby\/hash:BSON::Document/, '')
          # noinspection RubyResolve
          result = YAML.load(result)
          result.key_strings_to_symbols!(recursive: true)
        end

        def to_s
          self.name || "#{self.class.name}_#{self.id}"
        end

        protected

        def volatile_attributes
          %w'id created_at updated_at'
        end

        private

        def copy_attributes(other)
          self.set(
              other.attributes.reject do |k, _|
                volatile_attributes.include? k.to_s
              end.each_with_object({}) do |(k, v), h|
                h[k] = v.duplicable? ? v.dup : v
              end
          )
          self
        end

      end

    end
  end
end
