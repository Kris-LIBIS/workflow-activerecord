ActiveRecord::Schema.define do
  self.verbose = true

  enable_extension 'plpgsql'
  # enable_extension 'pgcrypto'

  create_table :workflows, force: true do |t|
    t.string :name
    t.text :description
    t.jsonb :config, default: {}

    t.timestamps
  end

  add_index :workflows, :config, using: :gin

  create_table :jobs, force: true do |t|
    t.string :type
    t.string :name
    t.text :description
    t.jsonb :input, default: {}
    t.string :run_object
    t.boolean :log_to_file, default: true
    t.boolean :log_each_run, default: true
    t.string :log_level, default: 'INFO'
    t.string :log_age, default: 'daily'
    # noinspection RubyResolve
    t.integer :log_keep, default: 5

    t.timestamps

    t.references :workflow, foreign_key: {to_table: :workflows, on_delete: :cascade}
    t.integer :workflow_id
  end

  create_table :work_items, force: true do |t|
    t.string :type
    t.jsonb :properties
    t.jsonb :options
    t.jsonb :status_log
    t.references :parent, foreign_key: {to_table: :work_items, on_delete: :cascade}
    t.references :job, foreign_key: {to_table: :jobs, on_delete: :cascade}
    t.timestamps
  end

  add_index :work_items, :status_log, using: :gin

end
