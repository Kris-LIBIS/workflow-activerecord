require 'libis/workflow/activerecord'

class CreateStatusesTable < ActiveRecord::Migration[5.0]

  # noinspection RubyResolve
  def change

    create_table :statuses do |t|
      t.string :task
      t.string :status, limit: 12
      t.integer :progress
      t.integer :max

      t.references :work_item, foreign_key: {to_table: :work_items, on_delete: :cascade}

      t.timestamps
    end

    add_index :statuses, [:task, :id]

  end
end
