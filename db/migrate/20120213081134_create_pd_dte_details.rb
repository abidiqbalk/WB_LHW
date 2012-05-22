class CreatePdDteDetails < ActiveRecord::Migration
  def change
    create_table :pd_dte_details do |t|

      t.timestamps
    end
  end
end
