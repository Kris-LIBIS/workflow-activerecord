require 'libis/workflow/activerecord'

Libis::Workflow::ActiveRecord::Config.database_connect

class CreatePropertiesTable < ActiveRecord::Migration[5.0]

  def change
    create_table :status_entries do |t|
      t.string :task
      t.string :status
      t.integer :progress
      t.integer :max
      t.datetime :created
      t.datetime :updated

      t.references :work_item, foreign_key: true
    end
  end
end