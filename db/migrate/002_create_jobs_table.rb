require 'libis/workflow/activerecord'

class CreateWorkflowItemsTable < ActiveRecord::Migration[5.0]

  def change
    create_table :jobs do |t|
      t.string :type
      t.string :name
      t.string :description
      t.jsonb :input
      t.string :run_object
      t.boolean :log_to_file, default: true
      t.boolean :log_each_run, default: true
      t.string :log_level, default: 'INFO'
      t.string :log_age, default: 'daily'
      # noinspection RubyResolve
      t.integer :log_keep, default: 5

      t.timestamps

      t.integer :run_id
      t.integer :workflow_id
    end

    add_index :jobs, :workflow_id
  end
end
