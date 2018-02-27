require 'libis/workflow/activerecord'

Libis::Workflow::ActiveRecord::Config.database_connect

class CreatePropertiesTable < ActiveRecord::Migration[5.0]

  def change
    create_table :properties do |t|
      t.string :name
      t.string :value

      t.references :item, foreign_key: true
    end
  end
end