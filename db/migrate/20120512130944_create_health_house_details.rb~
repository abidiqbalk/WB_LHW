class CreateHealthHouseDetails < ActiveRecord::Migration
  def change
    create_table :health_house_details do |t|
      t.references:health_house
      t.integer:lhw_code
      t.string:catchment_area
      t.boolean:community_chart
      t.text:diary
      t.integer:pregnent_women_new
      t.integer:pregnent_women_old
      t.integer:live_births
      t.integer:number_of_children
      t.integer:number_of_eligible_fp_clients
      t.integer:new_fp_clients
      t.integer:condom_stock
      t.integer:oral_contraceptive_pill_stock
      t.integer:injection_stock
      t.integer:paracetamol_stock
      t.integer:ors_stock		
      t.timestamps
    end
  end
end
