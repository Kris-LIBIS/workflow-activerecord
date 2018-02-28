ActiveRecord::Schema.define do
  self.verbose = true

  enable_extension 'plpgsql'
  # enable_extension 'pgcrypto'

  create_table :work_items, force: true do |t|
    t.string :type
    t.jsonb :options, null: false, default: {}
    t.jsonb :properties, null: false, default: {}
    t.jsonb :status_log, null: false, default: []
    t.references :parent#, polymorphic: true
  end

  add_index :work_items, :status_log, using: :gin

end
