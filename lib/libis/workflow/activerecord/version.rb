module Libis
  module Workflow
    module ActiveRecord
      VERSION = '1.0.0' unless const_defined? :VERSION # the guard is against a redefinition warning that happens on Travis
    end
  end
end
