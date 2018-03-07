require 'libis/workflow/activerecord'

class CreateWorkflowTable < ActiveRecord::Migration[5.0]

  def change

    create_table :workflows do |t|
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

  end
end
