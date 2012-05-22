class CreateDesignations < ActiveRecord::Migration
  def change
    create_table :designations do |t|

      t.timestamps
    end
  end
end
