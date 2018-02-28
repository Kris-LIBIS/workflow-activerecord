# encoding: utf-8

require 'rspec'
require_relative 'spec_helper'

require 'libis-workflow-activerecord'
require 'libis/workflow/activerecord/work_item'
require 'awesome_print'

describe 'TestWorkItem' do

  it 'create item' do
    item = Libis::Workflow::ActiveRecord::WorkItem.create(name: 'Foo')
    item.properties['name'] = 'Bar'
    item.save
    ap item
    ap item.properties
    item.save
  end
end
