ActiveRecord::Schema.define do
  self.verbose = true

  enable_extension 'plpgsql'
  enable_extension 'pgcrypto'

  create_table :options, force: true do |t|
    t.string :task
    t.string :name, null: false
    t.string :value

    t.references :work_item, polymorphic: true, null: false, index: true
  end

  create_table :properties, force: true do |t|
    t.string :name
    t.string :value

    t.references :work_item, polymorphic: true, null: false, index: true
  end

  create_table :status_entries, force:true do |t|
    t.string :task, :status
    # noinspection RubyResolve
    t.integer :progress, :max
    t.datetime :created, :updated

    t.references :work_item, polymorphic: true, null: false, index: true
  end

  create_table :work_items, force: true do |t|
    t.string :name
    t.integer :parent_id
  end

end
