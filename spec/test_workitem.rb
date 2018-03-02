require 'libis/workflow/activerecord/work_item'

class TestWorkItem < ::Libis::Workflow::ActiveRecord::WorkItem
  property_field :abc,
                 reader: lambda {|value| value.blank? ? :xyz : value.to_sym},
                 writer: lambda {|value| value.blank? ? nil : value.to_s}
end