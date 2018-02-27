require 'libis/workflow/activerecord'

Libis::Workflow::ActiveRecord::Config.database_connect

class CreateOptionsTable < ActiveRecord::Migration[5.0]

  def change
    create_table :options do |t|
      t.string :task
      t.string :name, null: false
      t.string :value

      t.references :item, foreign_key: true
    end
  end
end