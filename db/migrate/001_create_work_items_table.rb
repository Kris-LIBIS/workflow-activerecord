require 'libis/workflow/activerecord'

class CreateWorkflowItemsTable < ActiveRecord::Migration[5.0]

  def change
    create_table :work_items do |t|
      t.string :type
      t.jsonb :properties
      t.jsonb :options
      t.jsonb :status_log
      t.references :parent, foreign_key: {to_table: :work_items, on_delete: :cascade}

      t.timestamps
    end

    add_index :work_items, :status_log, using: :gin
  end
end
