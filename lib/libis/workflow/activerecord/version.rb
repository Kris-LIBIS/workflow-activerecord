module Libis
  module Workflow
    module ActiveRecord
      VERSION = '0.9.4' unless const_defined? :VERSION # the guard is against a redefinition warning that happens on Travis
    end
  end
end
