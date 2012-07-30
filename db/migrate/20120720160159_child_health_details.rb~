class ChildHealthDetails < ActiveRecord::Migration
  def up
create_table :child_health_details do |t|
      t.references:child_health
      t.integer:lhw_code
      t.string:name_of_child
      t.integer:age_in_month
      t.decimal:mid_upper_arm_circumference
      t.decimal:weight
      t.string:epi_status
      t.datetime:epi_polio_bcg
      t.datetime:penta1_polio
      t.datetime:penta2_polio
      t.datetime:penta3_polio
      t.datetime:measles1
      t.datetime:measles2
      t.timestamps
    end
  end

  
end
