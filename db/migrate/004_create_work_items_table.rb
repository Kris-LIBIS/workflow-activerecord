require 'libis/workflow/activerecord'

Libis::Workflow::ActiveRecord::Config.database_connect

class CreateWorkflowItemsTable < ActiveRecord::Migration[5.0]

  def change
    create_table :work_items do |t|
    end
  end
end
