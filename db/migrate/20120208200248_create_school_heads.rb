class CreateSchoolHeads < ActiveRecord::Migration
  def change
    create_table :school_heads do |t|
	  t.references :inspection
	  t.string :name
	  t.references :designation
	  t.string :contact_number
      t.timestamps
    end
  end
end