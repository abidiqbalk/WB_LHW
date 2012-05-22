class CreateMarkazs < ActiveRecord::Migration
  def change
    create_table :markazs do |t|

      t.timestamps
    end
  end
end
