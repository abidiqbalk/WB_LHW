class CreateAdditionalInspectionInfos < ActiveRecord::Migration
  def change
    create_table :additional_inspection_infos do |t|
      t.references :inspection
      t.integer :students_without_facilities
      t.integer :teachers_without_furniture
      t.integer :total_sections_k12
      t.integer :total_classrooms_k12
      t.string :student_cleanliness
      t.string :building_cleanliness
      t.string :lawns_cleanliness	  
      t.integer :teachers_in_ctsc
      t.boolean :dte_visited_last_month
      t.integer :bfm_recieved
      t.boolean :electricity_availability
      t.boolean :electricity_functionality
      t.boolean :drinking_water_availability
      t.boolean :drinking_water_functionality
      t.boolean :toilet_availability
      t.boolean :toilet_functionality
      t.timestamps
    end
  end
end
