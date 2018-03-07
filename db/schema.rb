ActiveRecord::Schema.define do
  self.verbose = true

  enable_extension 'plpgsql'

  # enable_extension 'pgcrypto'

  create_table :workflows, force: :cascade do |t|
    t.string :type
    t.string :name
    t.text :description
    if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
      t.jsonb :config, default: {}
    else
      t.json :config, default: {}
    end

    t.timestamps
  end

  if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
    add_index :workflows, :config, using: :gin
  end

  create_table :jobs, force: :cascade do |t|
    t.string :type
    t.string :name
    t.text :description
    if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
      t.jsonb :input, default: {}
    else
      t.json :input, default: {}
    end
    t.string :run_object
    t.boolean :log_to_file, default: true
    t.boolean :log_each_run, default: true
    t.string :log_level, default: 'INFO'
    t.string :log_age, default: 'daily'
    # noinspection RubyResolve
    t.integer :log_keep, default: 5

    t.references :workflow, foreign_key: {to_table: :workflows, on_delete: :cascade}

    t.timestamps
  end

  if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
    add_index :jobs, :input, using: :gin
  end

  create_table :work_items, force: :cascade do |t|
    t.string :type
    if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
      t.jsonb :properties
      t.jsonb :options
      t.jsonb :status_log
    else
      t.json :properties
      t.json :options
      t.json :status_log
    end
    t.references :parent, foreign_key: {to_table: :work_items, on_delete: :cascade}
    t.references :job, foreign_key: {to_table: :jobs, on_delete: :cascade}

    t.timestamps
  end

  if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
    add_index :work_items, :status_log, using: :gin
  end

end
