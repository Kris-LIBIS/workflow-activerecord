require 'libis/workflow/activerecord'
require 'libis/workflow/base/workflow'
require 'libis/tools/config_file'
require 'libis/tools/extend/hash'

module Libis
  module Workflow
    module ActiveRecord

      class Workflow < ::ActiveRecord::Base
        include ::Libis::Workflow::Base::Workflow
        include ::Libis::Workflow::ActiveRecord::Base

        serialize :input, Libis::Workflow::ActiveRecord::Helpers::HashSerializer

        # noinspection RailsParamDefResolve
        has_many :jobs,
                 -> {order('id')},
                 class_name: Libis::Workflow::ActiveRecord::Job.to_s,
                 foreign_key: :workflow_id,
                 autosave: true

        def self.from_hash(hash)
          self.create_from_hash(hash, [:name]) do |item, cfg|
            item.configure(cfg.merge('name' => item.name))
            cfg.clear
          end
        end

        def self.load(file_or_hash)
          config = Libis::Tools::ConfigFile.new
          config << file_or_hash
          return nil if config.empty?
          workflow = self.new
          workflow.configure(config.to_hash.key_symbols_to_strings(recursive: true))
          workflow
        end

      end
    end
  end
end
