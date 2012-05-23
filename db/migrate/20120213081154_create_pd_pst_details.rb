class CreatePdPstDetails < ActiveRecord::Migration
  def change
    create_table :pd_pst_details do |t|

      t.timestamps
    end
  end
end
