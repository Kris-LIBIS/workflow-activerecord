# encoding: utf-8

require 'rspec'
require_relative 'spec_helper'

require 'libis-workflow-activerecord'
require 'test_workitem'
require 'awesome_print'

describe 'TestWorkItem' do

  let :root do
    f = Libis::Workflow::ActiveRecord::WorkItem.where('properties @> ?', {name: 'root'}.to_json)
    return f.first if f.length > 0
    f = TestWorkItem.new
    f.properties[:name] = 'root'
    f.save
    f
  end

  it 'create item' do
    item = TestWorkItem.create
    ap item
    ap item.properties
    item.properties['name'] = 'Bar'
    item.options[:size] = 10000
    item.options[:info] = {}
    item.options['info'][:created] = Date.today
    item.save
    ap item
    ap item.options[:info][:created].class

    item.set_status('abc', :DONE)
    item.save
    ap item

    item.set_status('xyz', :STARTED)
    item.save
    ap item

    item.status_progress('xyz', 1, 10)
    item.save
    ap item

    item.status_progress('xyz', 4, 10)
    item.save
    ap item

    item.status_progress('xyz', 8, 10)
    item.save
    ap item

    item.status_progress('xyz', 10, 10)
    item.save
    ap item

    item.set_status('xyz', :DONE)
    item.save
    ap item

  end

  describe 'item hierachy' do

    it '1' do
      child = TestWorkItem.new
      child.properties[:name] = 'child 1'
      child.parent = root
      child.save
    end

    it '2' do
      child = TestWorkItem.new
      child.properties[:name] = 'child 2'
      root << child
    end

    it '3' do
      child = TestWorkItem.new
      child.properties[:name] = 'child 3'
      root.add_item(child)

      loaded_root = child.parent
      ap loaded_root.class.to_s
    end

  end

  describe 'load hierarchy' do
    it 'root element' do
      ap root
      ap root.class
    end

    it 'root from child 1' do
      child = TestWorkItem.where('properties @> ? ', {name: 'child 1'}.to_json).first
      ap child
      ap child.parent
      ap child.parent.class
    end
  end
end
