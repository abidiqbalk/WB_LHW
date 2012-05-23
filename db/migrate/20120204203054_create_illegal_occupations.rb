class CreateIllegalOccupations < ActiveRecord::Migration
  def change
    create_table :illegal_occupations do |t|
		t.references :inspection, :null=> false
		t.string :amount_occupied
		t.datetime :occupied_from
      t.timestamps
    end
  end
end
