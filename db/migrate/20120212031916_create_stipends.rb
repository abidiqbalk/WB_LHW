class CreateStipends < ActiveRecord::Migration
  def change
    create_table :stipends do |t|
      t.references :inspection
      t.integer :enrolled_6
      t.integer :enrolled_7
      t.integer :enrolled_8
      t.integer :enrolled_9
      t.integer :enrolled_10
      t.integer :eligible_6
      t.integer :eligible_7
      t.integer :eligible_8
      t.integer :eligible_9
      t.integer :eligible_10
      t.string :stipend_quarter
      t.string :stipend_year
      t.boolean :list_displayed
      t.timestamps
    end
  end
end
