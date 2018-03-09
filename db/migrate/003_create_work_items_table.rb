require 'libis/workflow/activerecord'

class CreateWorkItemsTable < ActiveRecord::Migration[5.0]

  def change

    create_table :work_items do |t|
      t.string :type
      if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
        t.jsonb :properties, default: {}
        t.jsonb :options, default: {}
      else
        t.json :properties, default: {}
        t.json :options, default: {}
      end
      t.references :parent, foreign_key: {to_table: :work_items, on_delete: :cascade}
      t.references :job, foreign_key: {to_table: :jobs, on_delete: :cascade}

      t.timestamps
    end

  end
end
