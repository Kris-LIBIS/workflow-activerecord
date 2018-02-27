# encoding: utf-8

require 'rspec'
require_relative 'spec_helper'
require 'stringio'

require 'libis-workflow-activerecord'
require_relative 'test_workitem'

describe 'TestWorkItem' do

  before :each do
    ::Libis::Workflow::ActiveRecord.configure do |cfg|
      # noinspection RubyResolve
      cfg.database_connect 'db/config.yml', :test
      cfg.logger.appenders =
          ::Logging::Appenders.string_io('StringIO', layout: ::Libis::Tools::Config.get_log_formatter)
    end
  end

  describe 'create item' do
    item = TestWorkItem.create
  end
end
