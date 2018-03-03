require 'yaml'

module Libis
  module Workflow
    module ActiveRecord

      module PropertyHelper
        def self.included(klass)
          klass.extend(ClassMethods)
        end

        module ClassMethods

          def property_field(name, options = {})
            default = options[:default]
            default = default.call if default.is_a? Proc
            if options[:type]
              # noinspection RubyResolve
              options.reverse_merge! reader: lambda {|value| value.blank? ? nil : YAML.load(value)},
                                     writer: lambda {|value| value ? YAML.dump(value) : nil}
            end
            self.send(:define_method, name, lambda {
              value = properties[name]
              (options[:reader] ? options[:reader].call(value) : value) || default
            })
            self.send(:define_method, "#{name}=", lambda {|value|
              value ||= default
              properties[name] = options[:writer] ? options[:writer].call(value) : value
            })
          end

        end

      end

    end
  end
end
