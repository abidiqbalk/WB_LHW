class CreatePreviousInspections < ActiveRecord::Migration
  def change
    create_table :previous_inspections do |t|
      t.references :inspection
      t.datetime :date_of_inspection
      t.references :designation

      t.timestamps
    end
  end
end
