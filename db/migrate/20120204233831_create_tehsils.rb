class CreateTehsils < ActiveRecord::Migration
  def change
    create_table :tehsils do |t|

      t.timestamps
    end
  end
end
