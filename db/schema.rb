ActiveRecord::Schema.define do
  self.verbose = true

  enable_extension 'plpgsql'
  # enable_extension 'pgcrypto'

  create_table :work_items, force: true do |t|
    t.string :type
    t.jsonb :properties
    t.jsonb :options
    t.jsonb :status_log
    t.references :parent, foreign_key: { to_table: :work_items, on_delete: :cascade }

    t.timestamps
  end

  add_index :work_items, :status_log, using: :gin

end
