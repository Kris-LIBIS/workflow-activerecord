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

  context 'creation' do

    it 'new item' do
      item = TestWorkItem.new
      expect(item.class).to be TestWorkItem
      expect(item.id).to be_nil
      item.save
      expect(item.id).not_to be_nil
    end

    it 'create item' do
      item = TestWorkItem.create
      expect(item.class).to be TestWorkItem
      expect(item.id).not_to be_nil
    end

  end

  context 'properties' do

    before :context do
      @item = TestWorkItem.create
    end

    after :context do
      # @item.delete
    end

    let(:item) { @item }

    # noinspection RubyResolve
    it 'empty on creation' do
      expect(item.properties).to be_a Hash
      expect(item.properties).to be_empty
    end

    it 'can add property fields with indifferent access' do
      item.properties['name'] = 'Foo'
      expect(item.properties['name']).to eql 'Foo'
      expect(item.properties[:name]).to eql 'Foo'

      item.properties[:label] = 'Bar'
      expect(item.properties[:label]).to eql 'Bar'
      expect(item.properties['label']).to eql 'Bar'

      # name and label are special properties
      expect(item.name).to eql 'Foo'
      expect(item.label).to eql 'Bar'

      item.name = 'Baz'
      expect(item.properties['name']).to eql 'Baz'

      item.label = 'Quux'
      expect(item.properties[:label]).to eql 'Quux'

      item.save
    end

  end

  context 'options' do

    before :context do
      @item = TestWorkItem.create
    end

    after :context do
      # @item.delete
    end

    let(:item) { @item }

    it 'add with indifferent access' do
      item.options['foo'] = 'bar'
      expect(item.options['foo']).to eql 'bar'
      expect(item.options[:foo]).to eql 'bar'

      item.options[:baz] = 'quux'
      expect(item.options[:baz]).to eql 'quux'
      expect(item.options['baz']).to eql 'quux'

      item.save
    end

    it 'multilevel with indifferent access' do
      item.options[:quux] = {}
      item.options[:quux]['foo'] = 'bar'
      expect(item.options['quux']['foo']).to eql 'bar'
      expect(item.options[:quux][:foo]).to eql 'bar'

      item.options['quux'][:baz] = 'quux'
      expect(item.options['quux'][:baz]).to eql 'quux'
      expect(item.options[:quux]['baz']).to eql 'quux'

      item.save
    end

  end

  context 'status' do

    before :context do
      @item = TestWorkItem.create
    end

    after :context do
      # @item.delete
    end

    let(:item) { @item }

    it 'added' do
      item.set_status('abc', :STARTED)
      expect(item.status_log.size).to be 1
      status_entry = item.status_log[0]
      expect(status_entry[:task]).to eql 'abc'
      expect(status_entry[:status]).to be :STARTED
      expect(item.check_status(:STARTED, 'abc')).to be_truthy
    end

    it 'updated' do
      item.set_status('abc', :DONE)
      expect(item.status_log.size).to be 1
      status_entry = item.status_log[0]
      expect(status_entry[:task]).to eql 'abc'
      expect(status_entry[:status]).to be :DONE
      expect(item.check_status(:DONE, 'abc')).to be_truthy
    end

    context 'with progress' do

      it 'created' do
        item.set_status('def', :STARTED)
        expect(item.status_log.size).to be 2
        status_entry = item.status_log[1]
        expect(status_entry[:task]).to eql 'def'
        expect(status_entry[:status]).to be :STARTED
        expect(item.check_status(:STARTED, 'def')).to be_truthy
      end

      it 'updated' do
        item.status_progress('def', 3, 10)
        expect(item.status_log.size).to be 2
        status_entry = item.status_log[1]
        expect(status_entry[:task]).to eql 'def'
        expect(status_entry[:status]).to be :STARTED
        expect(status_entry[:progress]).to be 3
        expect(status_entry[:max]).to be 10
      end
    end

  end

  context 'hierarchy' do

    before :context do
      @item = TestWorkItem.create
      @item.name = 'root'
    end

    after :context do
      # @item.delete
    end

    let(:root) { @item }

    it 'child via set parent' do
      item = TestWorkItem.new
      item.properties[:name] = 'child 1'
      item.parent = root
      expect(item.id).to be_nil
      item.save
      expect(item.id).not_to be_nil
      # noinspection RubyResolve
      expect(item.parent_id).to be root.id
      expect(item.parent).to be root
      expect(root.items.size).to be 1
      expect(root.items.first).to eql item
    end

    it 'child via <<' do
      item = TestWorkItem.new
      item.properties[:name] = 'child 2'
      root << item
      expect(item.id).not_to be_nil
      # noinspection RubyResolve
      expect(item.parent_id).to be root.id
      expect(item.parent).to be root
      expect(root.items.size).to be 2
      expect(root.items.last).to eql item
    end

    it 'child via add_item' do
      item = TestWorkItem.new
      item.properties[:name] = 'child 3'
      root.add_item item
      expect(item.id).not_to be_nil
      # noinspection RubyResolve
      expect(item.parent_id).to be root.id
      expect(item.parent).to eql root
      expect(root.items.size).to be 3
      expect(root.items[2]).to eql item
    end

    it 'grandchild via set parent' do
      item = TestWorkItem.new
      item.properties[:name] = 'grandchild 1 of 1'
      parent = TestWorkItem.where('properties @> ? ', {name: 'child 1'}.to_json).first
      item.parent = parent
      expect(item.id).to be_nil
      item.save
      expect(item.id).not_to be_nil
      # noinspection RubyResolve
      expect(item.parent_id).to be parent.id
      expect(item.parent).to be parent
      expect(parent.items.size).to be 1
      expect(parent.items.first).to eql item
      expect(item.parent.parent).to eql root
    end

    it 'cascade delete' do
      child = TestWorkItem.where('properties @> ? ', {name: 'child 1'}.to_json).first
      child.destroy
      expect(root.items.count).to be 2

      grandchild = TestWorkItem.where('properties @> ? ', {name: 'grandchild 1 of 1'}.to_json).first
      expect(grandchild).to be_nil
    end

  end

end
