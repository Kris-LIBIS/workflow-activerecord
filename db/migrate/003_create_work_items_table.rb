require 'libis/workflow/activerecord'

class CreateWorkItemsTable < ActiveRecord::Migration[5.0]

  def change

    create_table :work_items do |t|
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
end
