require 'libis/workflow/activerecord'

class CreateJobsTable < ActiveRecord::Migration[5.0]

  def change

    create_table :jobs do |t|
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

  end
end
