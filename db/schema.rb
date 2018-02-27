ActiveRecord::Schema.define do
  self.verbose = true

  enable_extension 'plpgsql'
  enable_extension 'pgcrypto'

  create_table :options do |t|
    t.string :task
    t.string :name, null: false
    t.string :value

    t.references :work_item, foreign_key: true, null: false
  end

  create_table :properties do |t|
    t.string :name
    t.string :value

    t.references :work_item, foreign_key: true, null: false
  end

  create_table :status_entries do |t|
    t.string :task
    t.string :status
    t.integer :progress
    t.integer :max
    t.datetime :created
    t.datetime :updated

    t.references :work_item, foreign_key: true, null: false
  end

  create_table :work_items do |t|
    t.references :parent, foreign_key: true, null: false
  end

end
