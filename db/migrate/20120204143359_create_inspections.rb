class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
	  t.string :emiscode, :null=>false 
	  t.string :aeo_name
	  t.string :officer_id
	  t.string :mea_name
	  t.string :contact_number
	  t.datetime :arrival_date
	  t.datetime :departure_date
	  t.references :user
      t.timestamps
    end
  end
end
